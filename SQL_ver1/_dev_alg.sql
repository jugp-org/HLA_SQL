-- ****************************************************************************************************
-- ����������������� �������� �����
-- ****************************************************************************************************

-- ****************************************************************************************************
-- ������
-- ****************************************************************************************************
    -- ��������� ���� XLA
    exec hla_XML_read @file_name='C:\WORK\NGS\DATA\hla.xml\hla.xml'
    Go

    -- ������� �� �����, ������� ���
    exec [hla_Hash_create]
    Go
 
-- ****************************************************************************************************
-- ������
-- ****************************************************************************************************
    -- ��������� ����    
    -- Exec fastQ_Data_read @file_name='C:\WORK\NGS\DATA\2017_08_23-HLAi-I-II-example\test.fastq'
    -- Exec fastQ_Data_read @file_name='C:\WORK\NGS\APP\Trimmomatic-0.36\IonXpress_032_21_07_17_115.out'
    Exec fastQ_Data_read @file_name='C:\WORK\NGS\DATA\2017_09_15_HLA_F-T055619Z-001\HLA_F\fq\R_2016_09_15_16_23_34_user_S5-00386-31-PKU_HLA-F_RHD_15.09.2016.IonXpress_072.fq'
    Go
    
    -- init
    Exec fastQ_Data_Init
    Go
 
    -- ������� �� �����, ������� ���
    Exec fastQ_Hash_Create
    Go
 
-- ****************************************************************************************************
-- ��������� ������ � �������
-- ****************************************************************************************************

    print '**************************************************'
    print '��������� ������ � �������'
    print '**************************************************'

	-- ==================================================
	-- ������� ������������� �-���
	-- ==================================================
	If object_id('tempdb..#part') Is Not null
		Drop table #part
	If object_id('tempdb..#part_cnt') Is Not null
		Drop table #part_cnt
	If object_id('tempdb..#part_cnt_max') Is Not null
		Drop table #part_cnt_max
 
    -- 00:30
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
    -- ���������� ���������� ������� ���� � ��������
    -- ==================================================
    -- 18:00
    Select eq_cnt = Count(*)
        ,rp.read_iid
        ,ep.uexon_iid
        Into #part_Cnt
        from #part rp With (Nolock Index=tmp_part_idx3)
            Inner Join hla_uexon_part ep With (Nolock) On ep.epart_id=rp.rpart_id 
            Inner Join hla_uexon e With (Nolock) On ep.uexon_iid=e.uexon_iid
            Inner Join hla_wreads r With (Nolock) On r.read_iid=rp.read_iid
        Where 1=1
            and e.uexon_len_x<=r.read_len_x
        Group by rp.read_iid,ep.uexon_iid

	If object_id('tempdb..#part') Is Not null
		Drop table #part
    Go

    -- 04:40
    Create Index tmp_part_cnt_idx1 On #part_cnt(read_iid,uexon_iid)

    -- �������� ��������� � ���������� ������� hla_part_cross
    -- 03:30
    If Object_id('hla_part_cross') Is Not null
         Drop table hla_part_cross
    Select t.*
        Into hla_part_cross
        From #part_Cnt t
    -- 09:00        
    Create Index hla_part_cross_idx1 On hla_part_cross(read_iid,uexon_iid,eq_cnt)
 
    -- �������� ��������� � ���������� ������� hla_wreads_max
    -- alter table hla_wreads_max add epart_pos_1 Int Null
    -- alter table hla_wreads_max add epart_iid_1 Int Null
    -- alter table hla_wreads_max add rpart_pos_1 Int Null
    -- 00:45
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
         from #part_Cnt pc With (Nolock)
             Inner Join hla_uexon e With (Nolock) On pc.uexon_iid=e.uexon_iid
             -- Inner Join hla_wreads wr With (Nolock) On wr.read_iid=pc.read_iid
         Where 1=1
            -- And wr.read_len_x>=e.uexon_len_x
            And pc.eq_cnt>=e.epart_cnt*0.7
         Order By pc.read_iid, pc.uexon_iid
	If object_id('tempdb..#part_cnt') Is Not null
		Drop table #part_cnt

    -- 01:00
    Create Index hla_wreads_max_idx1 On hla_wreads_max(read_iid,uexon_iid)
    Create Index hla_wreads_max_idx2 On hla_wreads_max(read_iid,wread_max_iid)
    Create Index hla_wreads_max_idx3 On hla_wreads_max(uexon_iid,wread_max_iid)
    Create Index hla_wreads_max_idx4 On hla_wreads_max(eq_cnt,wread_max_iid)
    Go

    -- ==================================================
	-- Cross ������� ������ ���������� ������
    -- ==================================================
	If object_id('tempdb..#part_ex') Is Not null
		Drop table #part_ex

    Select 
        wm.uexon_iid
        ,rp.read_iid
        -- ,rp.rpart_pos
        ,epart_pos = min(ep.epart_pos)
        -- ,rp.rpart_seq_x
        Into #part_ex
        From hla_wreads_max wm With (Nolock) 
            Inner Join hla_reads_part rp With (Nolock) On wm.read_iid=rp.read_iid
            Inner Join hla_uexon_part ep With (Nolock) On wm.uexon_iid=ep.uexon_iid and ep.epart_id=rp.rpart_id 
        Group By wm.uexon_iid,rp.read_iid
    Select count(*) From #part_ex
    Go

    Update hla_wreads_max
        Set epart_pos_1 = t.epart_pos
        From hla_wreads_max rm With (Nolock)
        Inner Join #part_ex t On t.uexon_iid=rm.uexon_iid And t.read_iid=rm.read_iid
    Go

    Update hla_wreads_max
        Set epart_iid_1 = ep.epart_id 
            ,rpart_pos_1 = rp.rpart_pos
        From hla_wreads_max rm With (Nolock)
        Inner Join hla_uexon_part ep On ep.uexon_iid=rm.uexon_iid And ep.epart_pos=rm.epart_pos_1
        Inner Join hla_reads_part rp With (Nolock) On rp.read_iid=rm.read_iid and rp.rpart_id=ep.epart_id
    Go

	If object_id('tempdb..#part_ex') Is Not null
		Drop table #part_ex
    Go

    -- ==================================================
	-- ���������� ������� ����
    -- ==================================================
    -- ������ �������� �����    
	-- �����������
    Update hla_wreads
            Set read_seq_x = REVERSE(read_seq_x)
               ,read_seq_e = REVERSE(read_seq_e)
               ,k_forward_back = 2
        From hla_wreads wr 
        Inner Join hla_wreads_max rm With (Nolock) On rm.read_iid=wr.read_iid And rm.k_forward_back=2
	-- �������� �� ��������������� � �������� ������������������
    -- ��� read_seq_e
    -- A->0->T
    -- T->3->A
    -- C->1->G
    -- G->2->C
    -- ��� read_seq_x
    -- Set uexon_seq_x	= Replace(Replace(Replace(Replace(uexon_seq,'A','0'),'C','1'),'G','2'),'T','3')
    -- 0->�->3
    -- 1->C->2
    -- 2->G->1
    -- 3->T->0
    Update hla_wreads
            Set read_seq_e	= Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(read_seq_e,'A','0'),'T','3'),'C','1'),'G','2'),'0','T'),'3','A'),'1','G'),'2','C')
               ,read_seq_x	= Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(read_seq_e,'0','A'),'3','T'),'1','C'),'2','G'),'T','0'),'A','3'),'G','1'),'C','2')
        From hla_wreads wr 
        Inner Join hla_wreads_max rm With (Nolock) On rm.read_iid=wr.read_iid And rm.k_forward_back=2
    -- ��. ������� ������
    Update hla_wreads_max
            Set uexon_iid = e.uexon_half_iid
        From hla_wreads_max rm
        Inner Join dna_hla.dbo.hla_uexon e With (Nolock) On e.uexon_iid=rm.uexon_iid
        Where rm.k_forward_back=2
    -- ������� ������� ��������� � ������
    Update hla_wreads_max
            Set epart_pos_1 = Len(e.uexon_seq_x)-epart_pos_1+1-12+1
        From hla_wreads_max rm
        Inner Join dna_hla.dbo.hla_uexon e With (Nolock) On e.uexon_iid=rm.uexon_iid
        Where rm.k_forward_back=2
    -- ������� ������� ���������
    Update hla_wreads_max
            Set rpart_pos_1 = Len(wr.read_seq_x)-rpart_pos_1+1-12+1
        From hla_wreads_max rm
        Inner Join hla_wreads wr With (Nolock) On wr.read_iid=rm.read_iid
        Where rm.k_forward_back=2

-- ****************************************************************************************************
-- ������������
-- ****************************************************************************************************

    print '**************************************************'
    print '������������'
    print '**************************************************'
 
	If Object_id('hla_texon_part') Is Not null
		Drop table hla_texon_part

    Select hp.uexon_iid
            ,hp.epart_id
            ,hp.epart_pos
            ,wm.wread_max_iid
        Into hla_texon_part
        From hla_uexon_part2 hp With (Nolock)
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
	-- �������� ��������� � ���������� �������
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

    Select * from hla_uexon where uexon_iid=5250
    Select * from hla_wreads where read_iid=3184

    GCTCCCACTCCTTGAGGTATTTCAGCACCGCTGTGTCGCGGCCCGGCCGCGGGGAGCCCCGCTACATCGCCGTGGAGTACGTAGACGACACGCAATTCCTGCGGTTCGACAGCGACGCCGCGATTCCGAGGATGGAGCCGCGGGAGCCGTGGGTGGAGCAAGAGGGGCCGCAGTATTGGGAGTGGACCACAGGGTACGCCAAGGCCAACGCACAGACTGACCGAGTGGCCCTGAGGAACCTGCTCCGCCGCTACAACCAGAGCGAGGCTG
    GCTCCCACTCCTTGAGGTATTTCAGCACCGCTGTGTCGCGGCCCGGCCGCGGGGAGCCCCGCTACATCGCCGTGGAGTACGTAGACGACACGCAATTCCTGCGGTTCGACAGCGACGCCGCGATTCCGAGGATGGAGCCGCGGGAGCCGTGGGTGGAGCAAGAGGGGCCGCAGTATTGGGAGTGGACCACAGGGTACGCCAAGGCCAACGCACAGACTGACCGAGTGGCCCTGAGGAACCTGCTCCGCCGCTACAACCAGAGCGAGGC
*/

