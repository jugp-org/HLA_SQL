-- ****************************************************************************************************
-- Последовательный алгоритм всего
-- ****************************************************************************************************

-- ****************************************************************************************************
-- Чтения
-- ****************************************************************************************************
	Select 'начало=',Getdate()
    DBCC FREEPROCCACHE
    DBCC DROPCLEANBUFFERS 
    Use DNA2_FASTQ
    Go

    -- Прочитать файл    
    print '**************************************************'
    print 'Чтение данных FastQ'
    print '**************************************************'
    -- Exec fastQ2_Data_read @file_name='C:\WORK\NGS\DATA\2017_09_29_20171002T164751Z-001\R_2017_08_11_13_18_59_user_S5-00384-36-KIR_Kofiadi_bg_PCOS-11-08-17_2015HLA-160_PCOS-54_IonXpress_054.fastq'
    Exec fastQ2_Data_read @file_name='C:\WORK\NGS\DATA\2017_09_27_hla_11_8-20170928T123327Z-001\R_2017_08_11_13_18_59_user_S5-00384-36-KIR_Kofiadi_bg_PCOS-11-08-17_2015HLA-153_PCOS-48_IonXpress_048.fastq'
    Go

    DBCC SHRINKFILE (N'DNA2_fastQ_log' , 0, TRUNCATEONLY)
    GO
 
    -- Разбить на части, сделать хэш
	Select 'create hash=',Getdate()
    print '**************************************************'
    print 'Part create FastQ'
    print '**************************************************'
    Exec fastQ2_Hash_Create
    Go

    DBCC SHRINKFILE (N'DNA2_fastQ_log' , 0, TRUNCATEONLY)
    GO
	Select 'create hash end=',Getdate()

 
-- ****************************************************************************************************
-- Сравнение чтений и экзонов
-- ****************************************************************************************************
    DBCC FREEPROCCACHE
    DBCC DROPCLEANBUFFERS 
    -- UPDATE STATISTICS hla_reads_part -- WITH fullscan

    Declare @curr_time  DateTime

    print '**************************************************'
    print 'Сравнение чтений и экзонов'
    print '**************************************************'

    Select @curr_time=Getdate()
   	Select 'Сравнение чтений и экзонов=',Getdate()

	-- ==================================================
	-- Таблица повторяющихся к-мер
	-- ==================================================
	If object_id('tempdb..#reads_buf') Is Not null
		Drop table #reads_buf
	If object_id('tempdb..#part_Cnt') Is Not null
		Drop table #part_Cnt
	If object_id('tempdb..#part_Cnt_max') Is Not null
		Drop table #part_Cnt_max
    If Object_id('hla_join') Is Not null
         Drop table hla_join

    print '*** Create #part_Cnt'

    -- vars
    Declare @min_read_iid   int
    -- tmp tables
    Create table #reads_buf (
         read_iid   Int
        ,read_len   int
    )
    Create table #part_Cnt (
         eq_cnt         Numeric(3)
        ,read_iid       Int
        ,uexon_iid      Int
        ,epart_cnt      Smallint
        ,k_forward_back Smallint
    )

    -- ==================================================
    -- Временная таблица совпадений
    -- #part_Cnt
    -- ==================================================
    Select @min_read_iid=Min(read_iid)
        From hla_reads r With (Nolock)
    While Isnull(@min_read_iid,0)<>0
    Begin
        Print 'step 1000 '+Cast(@min_read_iid As Varchar(20))
        Delete From #reads_buf
        Insert #reads_buf
    	    Select Top 2000 
                    r.read_iid
                  , r.read_len
                From hla_reads r With (Nolock)
                Where r.read_iid>=@min_read_iid
                Order By r.read_iid
        Select @min_read_iid=Max(read_iid)
            From #reads_buf
        If Isnull(@min_read_iid,0)=0
        Begin
        	Break
        End
        Select @min_read_iid=@min_read_iid+1

        Insert #part_Cnt
            Select eq_cnt       = Count(*)
                ,read_iid       = rp.read_iid
                ,uexon_iid      = ep.uexon_iid
                ,epart_cnt      = max(ep.epart_cnt)
                ,k_forward_back = max(ep.k_forward_back)
                from hla_reads_part rp With (Nolock)
                    Inner Join hla_reads_upart up With (Nolock) On up.rpart_hash=rp.rpart_hash
                    Inner Join dna2_hla.dbo.hla_uexon_part ep With (Nolock) On ep.epart_hash=rp.rpart_hash 
                    Inner Join #reads_buf r With (Nolock) On r.read_iid=rp.read_iid
                Where 1=1
                    and ep.uexon_len<=r.read_len
                Group by rp.read_iid,ep.uexon_iid
                -- OPTION (MAXDOP 1);

    End
    Select 'Create #reads_buf',DateDiff(second, @curr_time, Getdate())

    -- ==================================================
    -- Записать результат в постоянную таблицу hla_join
    -- ==================================================
    Select @curr_time=Getdate()
    print '*** Create hla_join'
    If Object_id('hla_join') Is Not null
         Drop table hla_join
    Select t.*
        Into hla_join
        From #part_Cnt t
 	If object_id('tempdb..#part_Cnt') Is Not null
		Drop table #part_Cnt
    Select 'Create hla_join',DateDiff(second, @curr_time, Getdate())

    -- ==================================================
    -- Проиндексировать таблицу hla_join
    -- ==================================================
    Select @curr_time=Getdate()
    --Create NonClustered Index hla_cross_idx1 
    --    On hla_join(read_iid,uexon_iid,eq_cnt) 
    --    with (SORT_IN_TEMPDB = On) 
    Select 'Create Index hla_join',DateDiff(second, @curr_time, Getdate())
    DBCC SHRINKFILE (N'DNA2_fastQ_log' , 0, TRUNCATEONLY)

    -- ==================================================
    -- Записать результат в постоянную таблицу hla_join_max
    -- ==================================================
    Select @curr_time=Getdate()
    print '*** Create table hla_join_max'
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
            ,j.k_forward_back
         from hla_join j With (Nolock)
         Where 1=1
            And j.eq_cnt>=j.epart_cnt*0.7
         Order By j.read_iid, j.uexon_iid
    Select 'Create table hla_join_max',DateDiff(second, @curr_time, Getdate())

    -- ==================================================
    -- Проиндесировать hla_join_max
    -- ==================================================
    Select @curr_time=Getdate()
    Create Index hla_cross_max_idx1 On hla_join_max(read_iid,uexon_iid)
    Create Index hla_cross_max_idx2 On hla_join_max(read_iid,join_max_iid)
    Create Index hla_cross_max_idx3 On hla_join_max(uexon_iid,join_max_iid)
    Create Index hla_cross_max_idx4 On hla_join_max(eq_cnt,join_max_iid)
    Select DateDiff(minute, @curr_time, Getdate())
    DBCC SHRINKFILE (N'DNA2_fastQ_log' , 0, TRUNCATEONLY)
    Select 'Create index hla_join_max',DateDiff(second, @curr_time, Getdate())

    -- ==================================================
	-- Обработать обраные риды
    -- ==================================================
    Select @curr_time=Getdate()
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

    DBCC SHRINKFILE (N'DNA2_fastQ_log' , 0, TRUNCATEONLY)
    Select 'back read process',DateDiff(second, @curr_time, Getdate())

	Select 'Завершено=',Getdate()

