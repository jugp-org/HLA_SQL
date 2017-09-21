-- ****************************************************************************************************
-- Послеждовательный алгоритм всего
-- ****************************************************************************************************


-- ****************************************************************************************************
-- Чтения
-- ****************************************************************************************************
	Use DNA_FASTQ

    -- Прочитать файл    
    -- Exec fastQ_Data_read @file_name='C:\WORK\NGS\DATA\2017_08_23-HLAi-I-II-example\test.fastq'
    -- Exec fastQ_Data_read @file_name='C:\WORK\NGS\APP\Trimmomatic-0.36\IonXpress_032_21_07_17_115.out'
    print '**************************************************'
    print 'Чтение данных FastQ'
    print '**************************************************'
    Exec fastQ_Data_read @file_name='C:\WORK\NGS\DATA\2017_09_15_HLA_F-T055619Z-001\HLA_F\fq\R_2016_09_15_16_23_34_user_S5-00386-31-PKU_HLA-F_RHD_15.09.2016.IonXpress_072.fq'
    Go

    DBCC SHRINKFILE (N'DNA_FASTQ_log' , 0, TRUNCATEONLY)
    GO
    
    -- init
    print '**************************************************'
    print 'Init FastQ'
    print '**************************************************'
    Exec fastQ_Data_Init
    Go

    DBCC SHRINKFILE (N'DNA_FASTQ_log' , 0, TRUNCATEONLY)
    GO
 
    -- Разбить на части, сделать хэш
    print '**************************************************'
    print 'Part create FastQ'
    print '**************************************************'
    Exec fastQ_Hash_Create
    Go

    DBCC SHRINKFILE (N'DNA_FASTQ_log' , 0, TRUNCATEONLY)
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
 
    -- 00:30
    print '*** Create #part'
    Select p.*
            , u.urpart_cnt
        Into #part
        From hla_reads_part p
        Inner Join hla_reads_upart u With (Nolock) On u.rpart_id=p.rpart_id
        -- Where u.urpart_cnt>6
 
    -- Create Index tmp_part_idx1 On #part(read_id)
    -- 00:30
    Create Index tmp_part_idx1 On #part(read_id,rpart_pos)
    Create Index tmp_part_idx2 On #part(rpart_id)
    Create Index tmp_part_idx3 On #part(rpart_id,read_iid)
    Go

    -- ==================================================
    -- Количество совпадений каждого рида с экзонами
    -- ==================================================
    -- 18:00
    print '*** Create #part_cnt'
    Select eq_cnt = Count(*)
        ,rp.read_iid
        ,ep.uexon_iid
        Into #part_Cnt
        from #part rp With (Nolock Index=tmp_part_idx3)
            Inner Join dna_hla..hla_uexon_part ep With (Nolock) On ep.epart_id=rp.rpart_id 
            Inner Join dna_hla..hla_uexon e With (Nolock) On ep.uexon_iid=e.uexon_iid
            Inner Join hla_wreads r With (Nolock) On r.read_iid=rp.read_iid
        Where 1=1
            and e.uexon_len_x<=r.read_len_x
        Group by rp.read_iid,ep.uexon_iid
    Go
	If object_id('tempdb..#part') Is Not null
		Drop table #part
    Go

    -- Записать результат в постоянную таблицу hla_part_cross
    -- 03:30
    print '*** Create hla_part_cross'
    If Object_id('hla_part_cross') Is Not null
         Drop table hla_part_cross
    Select t.*
        Into hla_part_cross
        From #part_Cnt t
    Go
 	If object_id('tempdb..#part_cnt') Is Not null
		Drop table #part_cnt
    Go
    -- 09:00        
    Create Index hla_part_cross_idx1 On hla_part_cross(read_iid,uexon_iid,eq_cnt)
    Go
    DBCC SHRINKFILE (N'DNA_FASTQ_log' , 0, TRUNCATEONLY)
    GO

    -- Записать результат в постоянную таблицу hla_wreads_max
    -- alter table hla_wreads_max add epart_pos_1 Int Null
    -- alter table hla_wreads_max add epart_iid_1 Int Null
    -- alter table hla_wreads_max add rpart_pos_1 Int Null
    -- alter table hla_wreads_max add seq_distance Int Null
    -- 00:45
    print '*** Create hla_wreads_max'
    If Object_id('hla_wreads_max') Is Not null
         Drop table hla_wreads_max
    Create table hla_wreads_max (
            wread_max_iid       Numeric(15) Identity(1,1)
            ,read_iid           Numeric(15)
            ,uexon_iid          Int
            ,uexon_name         varchar(20) 
            ,eq_cnt             Int
            ,k_forward_back     Smallint    Null
            ,epart_pos_1        Int         Null
            ,epart_iid_1        Int         Null
            ,rpart_pos_1        Int         Null
            ,seq_distance       Int         Null
        )
    Insert hla_wreads_max (
            read_iid        
            ,uexon_iid      
            ,uexon_name    
            ,eq_cnt
            ,k_forward_back
            )     
     Select pc.read_iid        
            ,pc.uexon_iid      
            ,e.uexon_name    
            ,pc.eq_cnt    
            ,e.k_forward_back
         from hla_part_cross pc With (Nolock)
             Inner Join dna_hla..hla_uexon e With (Nolock) On pc.uexon_iid=e.uexon_iid
             -- Inner Join hla_wreads wr With (Nolock) On wr.read_iid=pc.read_iid
         Where 1=1
            -- And wr.read_len_x>=e.uexon_len_x
            And pc.eq_cnt>=e.epart_cnt*0.7
         Order By pc.read_iid, pc.uexon_iid
    Go
    -- 01:00
    Create Index hla_wreads_max_idx1 On hla_wreads_max(read_iid,uexon_iid)
    Create Index hla_wreads_max_idx2 On hla_wreads_max(read_iid,wread_max_iid)
    Create Index hla_wreads_max_idx3 On hla_wreads_max(uexon_iid,wread_max_iid)
    Create Index hla_wreads_max_idx4 On hla_wreads_max(eq_cnt,wread_max_iid)
    Go
    DBCC SHRINKFILE (N'DNA_FASTQ_log' , 0, TRUNCATEONLY)
    GO

    -- ==================================================
	-- Cross таблица первых совпадащих частей
    -- ==================================================
	If object_id('tempdb..#part_ex') Is Not null
		Drop table #part_ex
    Go
    print '*** Вычисление первых совпадащих частей'
    Update hla_wreads_max
        Set  epart_iid_1    = 0     
            ,epart_pos_1    = 0
            ,rpart_pos_1    = 0
    Go
    DBCC SHRINKFILE (N'DNA_FASTQ_log' , 0, TRUNCATEONLY)
    GO

    Select 
        wm.uexon_iid
        ,rp.read_iid
        ,epart_pos = min(ep.epart_pos)
        Into #part_ex
        From hla_wreads_max wm With (Nolock) 
            Inner Join hla_reads_part rp With (Nolock) On wm.read_iid=rp.read_iid
            Inner Join dna_hla..hla_uexon_part ep With (Nolock) On wm.uexon_iid=ep.uexon_iid and ep.epart_id=rp.rpart_id 
        Group By wm.uexon_iid,rp.read_iid
    Select count(*) From #part_ex
    Go
    DBCC SHRINKFILE (N'DNA_FASTQ_log' , 0, TRUNCATEONLY)
    GO

    Update hla_wreads_max
        Set epart_pos_1 = t.epart_pos
        From hla_wreads_max rm With (Nolock)
        Inner Join #part_ex t On t.uexon_iid=rm.uexon_iid And t.read_iid=rm.read_iid
    Go
    DBCC SHRINKFILE (N'DNA_FASTQ_log' , 0, TRUNCATEONLY)
    GO

    Update hla_wreads_max
        Set epart_iid_1 = ep.epart_iid 
            ,rpart_pos_1 = rp.rpart_pos
        From hla_wreads_max rm With (Nolock)
        Inner Join dna_hla..hla_uexon_part ep On ep.uexon_iid=rm.uexon_iid And ep.epart_pos=rm.epart_pos_1
        Inner Join hla_reads_part rp With (Nolock) On rp.read_iid=rm.read_iid and rp.rpart_id=ep.epart_id
    Go
    DBCC SHRINKFILE (N'DNA_FASTQ_log' , 0, TRUNCATEONLY)
    GO

	If object_id('tempdb..#part_ex') Is Not null
		Drop table #part_ex
    Go


-- ****************************************************************************************************
-- Выравнивание
-- ****************************************************************************************************
/*
    print '**************************************************'
    print 'Выравнивание'
    print '**************************************************'
 
	If Object_id('hla_texon_part') Is Not null
		Drop table hla_texon_part

    Select hp.uexon_iid
            ,hp.epart_id
            ,hp.epart_pos
            ,wm.wread_max_iid
        Into hla_texon_part
        From dna_hla..hla_uexon_part2 hp With (Nolock)
        Inner Join hla_wreads_max wm With (Nolock) On wm.uexon_iid=hp.uexon_iid

	Create Index hla_texon_part_idx1 On hla_texon_part(wread_max_iid,epart_id,epart_pos)
	-- Create Index hla_texon_part_idx2 On hla_texon_part(uexon_iid,epart_pos)
    Go

    -- ==================================================
    If Object_id('hla_tread_part') Is Not null
         Drop table hla_tread_part
         
    Select rp.read_iid
        ,rp.rpart_pos
        ,rp.rpart_id
        ,wm.wread_max_iid
    Into hla_tread_part
    From hla_reads_part rp With (Nolock)
        Inner Join hla_wreads_max wm With (Nolock) On wm.read_iid=rp.read_iid 

    Create Index hla_tread_part_idx1 On hla_tread_part(wread_max_iid,rpart_id,read_iid,rpart_pos)
    -- Create Index hla_tread_part_idx2 On hla_tread_part(read_iid,rpart_pos)
    Go
*/

/*

    If object_id('tempdb..#texon_part') Is Not null
        Drop table #texon_part
    If object_id('tempdb..#tread_part') Is Not null
        Drop table #tread_part


    Select 'step1',Count(*)
        From hla_texon_part
    ---- ==================================================
    --Create Index tmp_texon_part_idx1 On #texon_part(wread_max_iid,epart_id,epart_pos)
    --Select 'step2',Count(*)
    --    From #texon_part
 
	-- **************************************************
	-- Записать результат в постоянные таблицы
	-- **************************************************
	If Object_id('hla_texon_part') Is Not null
		Drop table hla_texon_part
	Select *
		Into hla_texon_part
			From #texon_part

	Drop table #texon_part



 
  Select count(*)
    From hla_reads_part rp With (Nolock)
        Inner Join hla_wreads_max wm With (Nolock) On wm.read_iid=rp.read_iid 
 
    Select rp.read_iid
        ,rp.rpart_pos
        ,rp.rpart_id
        ,wm.wread_max_iid
    Into #tread_part
    From hla_reads_part rp With (Nolock)
        Inner Join hla_wreads_max wm With (Nolock) On wm.read_iid=rp.read_iid 
        --Where wm.eq_cnt>3
    Select 'step3',Count(*)
        From #tread_part
    -- ==================================================
    Create Index tmp_tread_part_idx1 On #tread_part(wread_max_iid,rpart_id,read_iid,rpart_pos)
    -- Create Index tmp_tread_part_idx2 On #tread_part(read_id,rpart_id,rpart_pos)
    Select 'step4',Count(*)
        From #tread_part


    If Object_id('hla_tread_part') Is Not null
         Drop table hla_tread_part
    Select *
        Into hla_tread_part
        From #tread_part
    Create Index hla_tread_part_idx1 On hla_tread_part(wread_max_iid,rpart_id,read_iid,rpart_pos)
    Create Index hla_tread_part_idx2 On hla_tread_part(read_iid,rpart_pos)

*/
/*
    Select Top 1000 * 
        From hla_wreads_max
        Where read_iid=5913

    Select 
             rp.read_iid
            ,ep.uexon_iid
            ,ep.epart_pos
            ,rp.rpart_pos
            ,diff=ep.epart_pos-rp.rpart_pos   
            ,ep.wread_max_iid
        From hla_tread_part rp With (Nolock)
        Inner Join hla_texon_part ep With (Nolock) On ep.wread_max_iid=rp.wread_max_iid And ep.epart_id = rp.rpart_id
        Where rp.read_iid=3184
           --  And ep.uexon_iid=157
        Order By  rp.read_iid
                 ,ep.uexon_iid
                 ,rp.rpart_pos
                 ,ep.epart_pos

    Select * from dna_hla..hla_uexon where uexon_iid=5250
    Select * from hla_wreads where read_iid=3184

    GCTCCCACTCCTTGAGGTATTTCAGCACCGCTGTGTCGCGGCCCGGCCGCGGGGAGCCCCGCTACATCGCCGTGGAGTACGTAGACGACACGCAATTCCTGCGGTTCGACAGCGACGCCGCGATTCCGAGGATGGAGCCGCGGGAGCCGTGGGTGGAGCAAGAGGGGCCGCAGTATTGGGAGTGGACCACAGGGTACGCCAAGGCCAACGCACAGACTGACCGAGTGGCCCTGAGGAACCTGCTCCGCCGCTACAACCAGAGCGAGGCTG
    GCTCCCACTCCTTGAGGTATTTCAGCACCGCTGTGTCGCGGCCCGGCCGCGGGGAGCCCCGCTACATCGCCGTGGAGTACGTAGACGACACGCAATTCCTGCGGTTCGACAGCGACGCCGCGATTCCGAGGATGGAGCCGCGGGAGCCGTGGGTGGAGCAAGAGGGGCCGCAGTATTGGGAGTGGACCACAGGGTACGCCAAGGCCAACGCACAGACTGACCGAGTGGCCCTGAGGAACCTGCTCCGCCGCTACAACCAGAGCGAGGC
*/

