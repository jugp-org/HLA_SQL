-- ****************************************************************************************************
-- Последовательный алгоритм всего
-- ****************************************************************************************************

-- ****************************************************************************************************
-- Чтения
-- ****************************************************************************************************
	Use DNA2_FASTQ
    Go

    -- Прочитать файл    
    -- Exec fastQ2_Data_read @file_name='C:\WORK\NGS\DATA\2017_08_23-HLAi-I-II-example\test.fastq'
    -- Exec fastQ2_Data_read @file_name='C:\WORK\NGS\APP\Trimmomatic-0.36\IonXpress_032_21_07_17_115.out'
    print '**************************************************'
    print 'Чтение данных FastQ'
    print '**************************************************'
    Exec fastQ2_Data_read @file_name='C:\WORK\NGS\DATA\2017_09_29_20171002T164751Z-001\R_2017_08_11_13_18_59_user_S5-00384-36-KIR_Kofiadi_bg_PCOS-11-08-17_2015HLA-160_PCOS-54_IonXpress_054.fastq'
    Go

    DBCC SHRINKFILE (N'DNA2_fastQ_log' , 0, TRUNCATEONLY)
    GO
 
    -- Разбить на части, сделать хэш
    print '**************************************************'
    print 'Part create FastQ'
    print '**************************************************'
    Exec fastQ2_Hash_Create
    Go

    DBCC SHRINKFILE (N'DNA2_fastQ_log' , 0, TRUNCATEONLY)
    GO
 
-- ****************************************************************************************************
-- Сравнение чтений и экзонов
-- ****************************************************************************************************

    print '**************************************************'
    print 'Сравнение чтений и экзонов'
    print '**************************************************'

	-- ==================================================
	-- Таблица повторяющихся к-мер
	-- ==================================================
	If object_id('tempdb..#part') Is Not null
		Drop table #part
	If object_id('tempdb..#part_cnt') Is Not null
		Drop table #part_cnt
	If object_id('tempdb..#part_cnt_max') Is Not null
		Drop table #part_cnt_max

    print '*** Create #part_cnt'

    -- ==================================================
    -- Количество совпадений каждого рида с экзонами
    -- ==================================================
    -- vars
    Declare @min_read_iid   int
    -- tmp tables
    Create table #part (
         read_iid   Int
        ,read_len   int
    )
    Create table #part_Cnt (
         eq_cnt     Numeric(3)
        ,read_iid   Int
        ,uexon_iid  Int
    )

    Select @min_read_iid=Min(read_iid)
        From hla_reads r With (Nolock)
    While Isnull(@min_read_iid,0)<>0
    Begin
        Print 'step 1000 '+Cast(@min_read_iid As Varchar(20))
        Delete From #part
        Insert #part
    	    Select Top 2000 
                    r.read_iid
                  , r.read_len
                From hla_reads r With (Nolock)
                Where r.read_iid>=@min_read_iid
                Order By r.read_iid
        Select @min_read_iid=Max(read_iid)
            From #part
        If Isnull(@min_read_iid,0)=0
        Begin
        	Break
        End
        Select @min_read_iid=@min_read_iid+1

        Insert #part_Cnt
            Select eq_cnt = Count(*)
                ,rp.read_iid
                ,ep.uexon_iid
                from hla_reads_part rp With (Nolock)
                    Inner Join dna2_hla.dbo.hla_uexon_part ep With (Nolock) On ep.epart_hash=rp.rpart_hash 
                    Inner Join dna2_hla.dbo.hla_uexon e With (Nolock) On ep.uexon_iid=e.uexon_iid
                    Inner Join #part r With (Nolock) On r.read_iid=rp.read_iid
                Where 1=1
                    and e.uexon_len<=r.read_len
                Group by rp.read_iid,ep.uexon_iid
    End
    Go

    --Select eq_cnt = Count(*)
    --    ,rp.read_iid
    --    ,ep.uexon_iid
    --    Into #part_Cnt
    --    from hla_reads_part rp With (Nolock)
    --        Inner Join dna2_hla.dbo.hla_uexon_part ep With (Nolock) On ep.epart_hash=rp.rpart_hash 
    --        Inner Join dna2_hla.dbo.hla_uexon e With (Nolock) On ep.uexon_iid=e.uexon_iid
    --        Inner Join hla_reads r With (Nolock) On r.read_iid=rp.read_iid
    --    Where 1=1
    --        and e.uexon_len<=r.read_len
    --    Group by rp.read_iid,ep.uexon_iid
    --Go

    -- Записать результат в постоянную таблицу hla_join
    -- 03:30
    print '*** Create hla_join'
    If Object_id('hla_join') Is Not null
         Drop table hla_join
    Select t.*
        Into hla_join
        From #part_Cnt t
    Go
 	If object_id('tempdb..#part_cnt') Is Not null
		Drop table #part_cnt
    Go
    -- 09:00        
    Create Index hla_cross_idx1 On hla_join(read_iid,uexon_iid,eq_cnt)
    Go
    DBCC SHRINKFILE (N'DNA2_fastQ_log' , 0, TRUNCATEONLY)
    GO

    -- Записать результат в постоянную таблицу hla_join_max
    print '*** Create hla_join_max'
    If Object_id('hla_join_max') Is Not null
         Drop table hla_join_max
    Create table hla_join_max (
             join_max_iid       Numeric(15) Identity(1,1)
            ,read_iid           Numeric(15)
            ,uexon_iid          Int
            ,eq_cnt             Int
            ,k_forward_back     Smallint    Null
        )
    Insert hla_join_max (
            read_iid        
            ,uexon_iid      
            ,eq_cnt
            ,k_forward_back
            )     
     Select  j.read_iid        
            ,j.uexon_iid      
            ,j.eq_cnt    
            ,e.k_forward_back
         from hla_join j With (Nolock)
             Inner Join dna2_hla.dbo.hla_uexon e With (Nolock) On j.uexon_iid=e.uexon_iid
         Where 1=1
            And j.eq_cnt>=e.epart_cnt*0.7
         Order By j.read_iid, j.uexon_iid
    Go
    -- 01:00
    Create Index hla_cross_max_idx1 On hla_join_max(read_iid,uexon_iid)
    Create Index hla_cross_max_idx2 On hla_join_max(read_iid,join_max_iid)
    Create Index hla_cross_max_idx3 On hla_join_max(uexon_iid,join_max_iid)
    Create Index hla_cross_max_idx4 On hla_join_max(eq_cnt,join_max_iid)
    Go
    DBCC SHRINKFILE (N'DNA2_fastQ_log' , 0, TRUNCATEONLY)
    GO

    -- ==================================================
	-- Обработать обраные риды
    -- ==================================================
    -- Список обратных ридов    
	-- Перевернули
    Update hla_reads
            Set read_seq = REVERSE(read_seq)
               ,k_forward_back = 2
        From hla_reads wr 
        Inner Join hla_join_max rm With (Nolock) On rm.read_iid=wr.read_iid And rm.k_forward_back=2
	-- Заменили на комплиментарную к исходной последовательности
    -- для read_seq_e
    -- A->0->T
    -- T->3->A
    -- C->1->G
    -- G->2->C
    -- для read_seq_x
    -- Set uexon_seq_x	= Replace(Replace(Replace(Replace(uexon_seq,'A','0'),'C','1'),'G','2'),'T','3')
    -- 0->А->3
    -- 1->C->2
    -- 2->G->1
    -- 3->T->0
    Update hla_reads
            Set read_seq	= Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(read_seq,'A','0'),'T','3'),'C','1'),'G','2'),'0','T'),'3','A'),'1','G'),'2','C')
        From hla_reads wr 
        Inner Join hla_join_max rm With (Nolock) On rm.read_iid=wr.read_iid And rm.k_forward_back=2
    -- Ид. прямого экзона
    Update hla_join_max
            Set uexon_iid = e.uexon_half_iid
        From hla_join_max rm
        Inner Join dna2_hla.dbo.hla_uexon e With (Nolock) On e.uexon_iid=rm.uexon_iid
        Where rm.k_forward_back=2

    Go
    DBCC SHRINKFILE (N'DNA2_fastQ_log' , 0, TRUNCATEONLY)
    GO


