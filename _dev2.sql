 -- ****************************************************************************************************
 -- Сервис
 -- ****************************************************************************************************

 /* --***
 use dna2_hla
 Declare @id     Bigint
        ,@sid    Varchar(50)
        ,@tid    Bigint
        ,@tsid   Varchar(50)
 Select @id  = 4765062  
 Select @sid = '210211320201'
 -- Select @sid = '013111013110323200'
 
use dna2_hla
go

Select *
    from hla_uexon
    where uexon_iid=1

Select ep.*
        ,ue.uexon_seq
    from hla_uexon_part ep
    inner join hla_uexon ue on ue.uexon_iid=ep.uexon_iid
    where ep.uexon_iid=1
    order by ep.epart_pos


 Select @tid=cast(Substring(@sid,1,1)
             +Substring(@sid,2,1)*4
             +Substring(@sid,3,1)*16
             +Substring(@sid,4,1)*64
             +Substring(@sid,5,1)*256
             +Substring(@sid,6,1)*1024
             +Substring(@sid,7,1)*4096
             +Substring(@sid,8,1)*16384
             +Substring(@sid,9,1)*65536
             +Substring(@sid,10,1)*262144
             +Substring(@sid,11,1)*1048576
             +Substring(@sid,12,1)*4194304
             --+Substring(@sid,13,1)*16777216
             --+Substring(@sid,14,1)*67108864
             --+cast(Substring(@sid,15,1) As Bigint)*268435456
             --+cast(Substring(@sid,16,1) As Bigint)*1073741824
             --+cast(Substring(@sid,17,1) As Bigint)*4294967296
             --+cast(Substring(@sid,18,1) As Bigint)*17179869184 
             As Bigint)
 

-- CTATTTCTTTGCAGACTTATGTGCACAGTGCGGTGTTGGCAGGAGGCGTGGCTGTGGGTACCTCGTGTCGCCTGATCCCTTCTCCGTGGCTTGCCATGGTGCTGGGTCTTGTGGCTGGGCTGATCTCCATCGGGGGAGCCAAGTGCCTGCCGGTAAGAAACTAGACAACTAATGCTCTCTGCTTTGGCTGAAGGCCAGCAGGATGCTGGGACCTGATGGGCCACTG
-- 130333133321 
--  303331333210
--   033313332102
--    333133321020
  
-- AGAATTACCTTT TCCAGGGACCGC AGGAATGCTACG CGTTTAATGGGA CACAGCGCTTCCTGGAGAGATACATCTACAACCGGGAGGAGTTCGCGCGCTTCGACAGCGACGTGGGGGAGTTCCGGGCGGTGACGGAGCTGGGGCGGCCTGCTGCGGAGTACTGGAACAGCCAGAAGGACATCCTGGAGGAGAAGCGGGCAGTGCCGGACAGGATGTGCAGACACAACTACGAGCTGGGCGGGCCCATGACCCTGCAGCGCCGAG
-- 020033011333 311022201121 022003213012 123330032220
declare  @tid   bigint
        ,@tsid  varchar(20)

Select @tid=16600840
Select @tid=6629911
Select @tid=9661480
Select @tid=2802681

Select @tid=7331789
Select @tid=1832947
Select @tid=8846844
Select @tid=2211711


Select @tsid = Cast((@tid % 4) As Varchar(1))
         +Cast((Floor (@tid/4) % 4) As Varchar(1))
         +Cast((FLOOR (@tid/16) % 4) As Varchar(1))
         +Cast((FLOOR (@tid/64) % 4) As Varchar(1))
         +Cast((FLOOR (@tid/256) % 4) As Varchar(1))
         +Cast((FLOOR (@tid/1024) % 4) As Varchar(1))
         +Cast((FLOOR (@tid/4096) % 4) As Varchar(1))
         +Cast((FLOOR (@tid/16384) % 4) As Varchar(1))
         +Cast((FLOOR (@tid/65536) % 4) As Varchar(1))
         +Cast((FLOOR (@tid/262144) % 4) As Varchar(1))
         +Cast((FLOOR (@tid/1048576) % 4) As Varchar(1))
         +Cast((FLOOR (@tid/4194304) % 4) As Varchar(1))
         --+Cast((FLOOR (@tid/16777216) % 4) As Varchar(1))
         --+Cast((FLOOR (@tid/67108864) % 4) As Varchar(1))
         --+Cast((FLOOR (@tid/268435456) % 4) As Varchar(1))
         --+Cast(Cast(FLOOR (@tid/1073741824) % 4 As Int) As Varchar(1))
         --+Cast(cast(FLOOR (@tid/4294967296) % 4 As int) As Varchar(1))
         --+Cast(cast(FLOOR (@tid/17179869184) % 4 As int) As Varchar(1))
 
 Select @tid,@tsid
 
 */


-- ****************************************************************************************************
-- Hla3
-- ****************************************************************************************************
    -- ==================================================
	-- Список экзонов 
    -- ==================================================
	Select a.allele_name
		,Substring(a.allele_name,1,Charindex('*',a.allele_name))
		,a.hla_g_group
        ,a.allele_id
        ,ue.uexon_uid
        ,ue.uexon_diff_seq
		,f.*
	From hla3_features f With (Nolock)
 		Inner Join hla3_alleles a With (Nolock) On a.allele_iid = f.allele_iid
 		Inner Join hla3_uexon ue With (Nolock) On ue.uexon_seq=f.feature_nucsequence
	Where 1=1
 		--and (
 		--	(f.feature_name In ('Exon 2', 'Exon 3') And Len(Substring(a.allele_name,1,Charindex('*',a.allele_name)))=6)
 		--	or
 		--	(f.feature_name In ('Exon 2') And Len(Substring(a.allele_name,1,Charindex('*',a.allele_name)))=9)
 		--)
 		--And a.allele_name In ('HLA-C*06:116N') 
        And a.hla_g_group In ('C*06:02:01G')
 		--And f.feature_nucsequence='GTTCTCACACCCTCCAGTGGATGATTGGCTGCGACCTGGGGTCCGACGGACGCCTCCTCCGCGGGTATGAACAGTATGCCTACGATGGCAAGGATTACCTCGCCCTGAACGAGGACCTGCGCTCCTGGACCGCAGCGGACACTGCGGCTCAGATCTCCAAGCGCAAGTGTGAGGCGGCCAATGTGGCTGAACAAAGGAGAGCCTACCTGGAGGGCACGTGCGTGGAGTGGCTCCACAGATACCTGGAGAACGGGAAGGAGATGCTGCAGCGCGCGG'
 		--And f.feature_nucsequence='GTTCTCACACCCTCCAGTGGATGATTGGCTGCGACCTGGGGTCCGACGGACGCCTCCTCCGCGGGTATGAACAGTATGCCTACGATGGCAAGGATTACCTCGCCCTGAACGAGGACCTGCGCTCCTGGACCGCAGCGGACACTGCGGCTCAGATCTCCAAGCGCAAGTGTGAGGCGGCCAATGTGGCTGAACAAAGGAGAGCCTACCTGGAGGGCACGTGCGTGGAGTGGCTCCACAGATACCTGGAGAACGGGAAGGAGATGCTGCAGCGCGCG*'
 		--And f.feature_nucsequence Like '%CACGTTTCCTGTGGCAGCCTAAGAGGGAGTGTCATTTCTTCAATGGGACGGAGCGGGTGCGGTTCCTGGACAGATACTTCTATAATCAGGAGGAGTCCGTGCGCTTCGACAGCGACGTGGGGGAGTTCCGGGCGGTGACGGAGCTGGGGCGGCCTGACGCTGAGTACTGGAACAGCCAGAAGGACATCCTGGAGCAGGCGCGGGCCGCGGTGGACACCTACTGCAGACACAACTACGGGGTTGGTG________________________%'
	Order By f.feature_name, a.allele_name  


    -- ==================================================
	-- Список экзонов с [*]
    -- ==================================================
	Select a.allele_name
		,Substring(a.allele_name,1,Charindex('*',a.allele_name))
		,f.*
	From hla3_features f With (Nolock)
 		Inner Join hla3_alleles a With (Nolock)
				On a.allele_iid = f.allele_iid
	Where 1=1
 		and (
 			(f.feature_name In ('Exon 2', 'Exon 3') And Len(Substring(a.allele_name,1,Charindex('*',a.allele_name)))=6)
 			or
 			(f.feature_name In ('Exon 2') And Len(Substring(a.allele_name,1,Charindex('*',a.allele_name)))=9)
 			)
 		And Charindex('*',f.feature_nucsequence)>0
 		And Replace(f.feature_nucsequence,'*','')=''
	Order By f.feature_name, a.allele_name  

    -- ==================================================
	-- Совпадение экзонов с [*] с любыми другими по маске
    -- ==================================================
	;With _cte_aster As (
			Select a.allele_name
				,a.allele_iid
				,f.feature_iid
				,f.feature_name
				,feature_nucsequence	= Replace(f.feature_nucsequence,'*','_')
			From hla3_features f With (Nolock)
 				Inner Join hla3_alleles a With (Nolock)
						On a.allele_iid = f.allele_iid
			Where 1=1
 				and (
 					(f.feature_name In ('Exon 2', 'Exon 3') And Len(Substring(a.allele_name,1,Charindex('*',a.allele_name)))=6)
 					or
 					(f.feature_name In ('Exon 2') And Len(Substring(a.allele_name,1,Charindex('*',a.allele_name)))=9)
 					)
 				And Charindex('*',f.feature_nucsequence)>0
 				And Replace(f.feature_nucsequence,'*','')<>''
	)
	, _cte_uexon As (
			Select Distinct f.feature_nucsequence
			From hla3_features f With (Nolock)
			Where 1=1
 				And Charindex('*',f.feature_nucsequence)=0
	)
	Select	
			allele_name1	= t.allele_name
			,allele_id1		= t.allele_iid
			,feature_id1	= t.feature_iid
			,feature_seq1	= t.feature_nucsequence
			,feature_name1	= t.feature_name
			--,allele_name2	= a.allele_name
			--,allele_id2		= a.allele_id
			--,feature_id2	= f.feature_iid
			,feature_seq2	= f.feature_nucsequence
		From _cte_aster t
 		Inner Join hla3_alleles a With (Nolock)
				On a.allele_iid = t.allele_iid
		inner Join _cte_uexon f with (NoLock) On f.feature_nucsequence Like t.feature_nucsequence  
	Order By t.feature_name, t.allele_name  

    -- ==================================================
    -- Список похожих последовательностей
    -- Одна длиннее - другая короче и... совпадают :)
    -- ==================================================
    If Object_id('tempdb..#_lst_uexon') is Not null
        Drop table #_lst_uexon
    If Object_id('tempdb..#_dbl_uexon') is Not null
        Drop table #_dbl_uexon

    --Select Max(Len(uexon_seq))
    --    From hla3_uexon 

    Select *
        ,uexon_sseq = Cast(Substring(uexon_seq,1,500) As Varchar(500))
        into #_lst_uexon
        From hla3_uexon
    
    Create Nonclustered Index [_tmp_uexon_idx1] On [#_lst_uexon](uexon_num,uexon_sseq,uexon_uid)

    Select 
            uexon_uid1  = ue1.uexon_uid
            ,uexon_uid2 = ue2.uexon_uid
            ,uexon_seq1 = ue1.uexon_sseq
            ,uexon_seq2 = ue2.uexon_sseq
        Into #_dbl_uexon
        From [#_lst_uexon] ue1
        Inner Join [#_lst_uexon] ue2 
            On ue1.uexon_num=ue2.uexon_num 
               and ue1.uexon_sseq Like ue2.uexon_sseq+'%'
               And ue1.uexon_uid<>ue2.uexon_uid
    Select * 
        From #_dbl_uexon        


    -- ==================================================
    -- Список аллелей класса I с экзонами
    -- ==================================================
    If Object_id('tempdb..#_allele') is Not null
        Drop table #_allele
    If Object_id('tempdb..#_allele1') is Not null
        Drop table #_allele1

    ;With _cte2 As (
        Select a.*
                ,exon2_uid  = ue.uexon_uid
            From hla3_alleles a
                Inner Join hla3_features f With (Nolock) On f.allele_iid=a.allele_iid And f.feature_name='Exon 2'
                Inner Join hla3_uexon ue With (Nolock) On ue.uexon_seq=f.feature_nucsequence
            Where Substring(a.allele_name,1,5) In ('HLA-A','HLA-B','HLA-C')
    ), _cte3 as (
        Select a.*
                ,exon3_uid  = ue.uexon_uid
            From hla3_alleles a
                Inner Join hla3_features f With (Nolock) On f.allele_iid=a.allele_iid And f.feature_name='Exon 3'
                Inner Join hla3_uexon ue With (Nolock) On ue.uexon_seq=f.feature_nucsequence
            Where Substring(a.allele_name,1,5) In ('HLA-A','HLA-B','HLA-C')
    )
    Select Distinct
            --allele_iid      = t2.allele_iid 
             allele_name    = case when t2.hla_g_group='None' then Replace(t2.allele_name,'HLA-','') Else t2.hla_g_group End 
            ,allele_g_group = t2.hla_g_group
            ,exon2_uid      = t2.exon2_uid
            ,exon3_uid      = t3.exon3_uid
            Into #_allele
        From _cte2 t2
            Inner Join _cte3 t3 On t2.allele_iid=t3.allele_iid
        Order By allele_name

    Select *
        From #_allele
    Create Index _tmp_allele On #_allele(exon2_uid)
    Create Index _tmp_allele1 On #_allele(exon3_uid)

/*
    -- ==================================================
    11020	HLA-C*07:27:01	    None	        4981	10014      a1
    10924	HLA-C*07:19	        None	        4940	10234      a3
    -- ==================================================
    10624	HLA-C*07:01:01:01	C*07:01:01G	    4940	10014      a4
    10700	HLA-C*07:02:01:01	C*07:02:01G	    4981	10234      a2
    -- ==================================================
*/
    Select   a1_name    = a1.allele_name
            ,a1_ex2     = a1.exon2_uid
            ,a1_ex3     = a1.exon3_uid
            ,a2_name    = a2.allele_name
            ,a2_ex2     = a2.exon2_uid
            ,a2_ex3     = a2.exon3_uid
            ,a3_name    = a3.allele_name
            ,a3_ex2     = a3.exon2_uid
            ,a3_ex3     = a3.exon3_uid
            ,a4_name    = a4.allele_name
            ,a4_ex2     = a4.exon2_uid
            ,a4_ex3     = a4.exon3_uid
        Into  #_allele1
        From #_allele a1
            Inner Join #_allele a2 On a2.exon2_uid=a1.exon2_uid And a2.exon3_uid<>a1.exon3_uid
            Inner Join #_allele a3 On a3.exon2_uid<>a2.exon2_uid And a3.exon3_uid=a2.exon3_uid
            Inner Join #_allele a4 On a4.exon2_uid=a3.exon2_uid And a4.exon3_uid<>a3.exon3_uid And a4.exon3_uid=a1.exon3_uid
        Where 1=1
--            and a1.allele_name Like 'C*%'
            and a1.allele_name<>a2.allele_name
            and a1.allele_name<>a3.allele_name
            and a1.allele_name<>a4.allele_name
            and a2.allele_name<>a3.allele_name
            and a2.allele_name<>a4.allele_name
            and a3.allele_name<>a4.allele_name
        Order By a1.allele_name

    -- Полный список
    Select t1.*
        From #_allele1 t1

    -- Список уникальных
    Select   a1_name    
            ,a1_ex2     
            ,a1_ex3     

            ,a3_name    
            ,a3_ex2     
            ,a3_ex3     

            ,a2_name    
            ,a2_ex2     
            ,a2_ex3     

            ,a4_name    
            ,a4_ex2     
            ,a4_ex3     
        From #_allele1 t1
        Where t1.a1_name < t1.a3_name
        order by t1.a1_name,t1.a2_name,t1.a3_name,t1.a4_name


-- ****************************************************************************************************
-- Hla2
-- ****************************************************************************************************
	
 -- ****************************************************************************************************
 -- Экзоны
 -- ****************************************************************************************************
    Select Substring(a.allele_name,1,Charindex('*',a.allele_name))
            ,Substring(a.allele_name,1,Charindex(':',a.allele_name))
            ,a.*
        From [dna2_hla].[dbo].[hla_alleles] a
        Where 1=1
        Order By a.allele_name
--			and a.allele_name Like 'HLA-DRB1*%'
			--And a.release_confimed='confirmed' 

    -- Список экзонов
    Select a.allele_name
            ,a.hla_g_group
            ,f.feature_name
            ,f.feature_nucsequence
            ,f.*
        From [dna2_hla].[dbo].hla_features f with (NoLock) 
		Inner Join dna2_hla.dbo.hla_alleles a with (NoLock) On a.allele_id=f.allele_id 
        Where 1=1
			and f.feature_type = 'Exon'
			and f.feature_name in ('Exon 2','Exon 3','Exon 4')
            --And (
            --    (f.feature_name='Exon 2' And a.allele_name Like 'HLA-D%')
            --    Or
            --    (f.feature_name in ('Exon 2','Exon 3','Exon 4') And Substring(a.allele_name,1,5) In ('HLA-A','HLA-B','HLA-C'))
            --)
			and f.[feature_status]='Complete'
			-- and a.allele_name Like 'HLA-DPB1*%'
--			And a.release_confimed='confirmed' 
--          And a.allele_name='HLA-DRB1*12:60N'
        Order by f.feature_name
                ,a.allele_name
                ,f.feature_nucsequence


    -- Список уникальных экзонов 
    Select e.*
        From dna2_hla.dbo.hla_uexon e With (Nolock)
        Where 1=1
           -- And e.uexon_seq='CACGTTTCTTGGAGCTGCTTAAGTCTGAGTGTCATTTCTTCAATGGGACGGAGCGGGTGCGGTTCCTGGAGAGACACTTCCATAACCAGGAGGAGTACGCGCGCTTCGACAGCGACGTGGGGGAGTACCGGGCGGTGAGGGAGCTGGGGCGGCCTGATGCCGAGTACTGGAACAGCCAGAAGGACCTCCTGGAGCAGAAGCGGGGCCAGGTGGACAATTACTGCAGACACAACTACGGGGTTGGTGAGAGCTTCACAGTGCAGCGGCGAG'
           And e.uexon_uid=2448
        Order By e.uexon_iid


    -- Список уникальных экзонов 
    -- в привязке к исходным данным
    Select f.allele_id
          ,f.feature_name
          ,a.allele_name
          ,a.hla_g_group
          ,e.uexon_len
          ,e.*
        From dna2_hla..hla_uexon e With (Nolock)
            Inner Join dna2_hla.dbo.hla_features f With (Nolock) On f.feature_nucsequence = e.uexon_seq
            Inner Join dna2_hla.dbo.[hla_alleles] a With (Nolock) On a.allele_id=f.allele_id
        Where 1=1
--            and f.feature_name='Exon 2'
--            And a.allele_name Like '%DPB%'
--            And a.allele_name Like 'HLA-A*%'
                And a.allele_name Like '%DRB1*14:141%'
        Order By a.allele_name,f.feature_name,f.alignmentreference_alleleid

    -- Список уникальных экзонов для аллелей
    -- в привязке к исходным данным
    Select f.allele_id
          ,f.feature_name
          ,a.allele_name
          ,e.uexon_len
          ,e.*
        From dna2_hla..hla_uexon e With (Nolock)
            Inner Join dna2_hla.dbo.hla_features f With (Nolock) On f.feature_nucsequence = e.uexon_seq
            Inner Join dna2_hla.dbo.[hla_alleles] a With (Nolock) On a.allele_id=f.allele_id
        Where 1=1
            And a.allele_name In ('HLA-B*07:02:45','HLA-B*07:161N')
        Order By a.allele_name,f.feature_name,f.alignmentreference_alleleid

    -- Кол-во уникальных экзонов по экзонам и генам
    -- в привязке к исходным данным
    ;With _cte_ex As (
        Select e.uexon_iid
              ,exon_num = f.feature_name
              ,gen_cd   = Substring(a.allele_name,1,Charindex('*',a.allele_name))
            From dna2_hla.dbo.hla_uexon e With (Nolock)
                Inner Join dna2_hla.dbo.hla_features f With (Nolock) On f.feature_nucsequence = e.uexon_seq
                Inner Join dna2_hla.dbo.[hla_alleles] a With (Nolock) On a.allele_id=f.allele_id
            Group By e.uexon_iid
                ,Substring(a.allele_name,1,Charindex('*',a.allele_name))
                ,f.feature_name
    ) 
    Select Count(*)
            ,exon_num 
            ,gen_cd   
        From _cte_ex
        Group By exon_num,gen_cd  
        Order By  gen_cd  , exon_num

    -- Проверка уникальности экзонов в пределеах одного гена
    Select gen_cd,uexon_seq 
        From hla_uexon
        Group By gen_cd,uexon_seq 
        having Count(*)>1

    -- Проверка уникальности экзонов 
    Select Max(uexon_uid)
            ,uexon_seq 
            ,Min(gen_cd)
            ,Max(gen_cd)
            ,Count(*)
        From hla_uexon
        Where k_forward_back=1
        Group By uexon_seq 
        having Count(*)>1

    Select uexon_uid
            ,Min(gen_cd)
            ,Max(gen_cd)
            ,Count(*)
        From hla_uexon
        Where k_forward_back=1
        Group By uexon_uid
        having Count(*)>1
        Order By uexon_uid



    -- Список уникальных длин экзонов 
    -- в привязке к исходным данным
    Select Distinct
           f.feature_name
          ,Substring(a.allele_name,1,Charindex('*',a.allele_name))
          ,e.uexon_len
        From dna2_hla..hla_uexon e With (Nolock)
            Inner Join dna2_hla.dbo.hla_features f With (Nolock) On f.feature_nucsequence = e.uexon_seq
            Inner Join dna2_hla.dbo.[hla_alleles] a With (Nolock) On a.allele_id=f.allele_id
        Where 1=1
--            and f.feature_name='Exon 2'
--            And a.allele_name Like '%DPB%'
--            And a.allele_name Like 'HLA-A*%'
        Order By e.uexon_len
                ,f.feature_name
                ,Substring(a.allele_name,1,Charindex('*',a.allele_name))

    -- Поиск последовательности в уникальном экзоне
    Declare @read_str Varchar(1024)
    Select @read_str='AACACCCAAAGACACACGTGACCCACCATCCCGTCTCTGACCATGAGGCCACCCTGAGGTGCTGGGCCCTGGGCTTCTACCCTGCGGAGATCACACTGACCTGGCAGCGGGATGGCGAGGACCAAACTCAGGACACCGAGCTTGTGGAGACCAGGCCAGCAGGAGATGGAACCTTCCAGAAGTGGGCAGCTGTGGTGGTGCCTTCTGGAGAAGAGCAGAGATACACGTGCCATGTGCAGCACGAGGGGCTGCC.AGAGCCCCTCACCCTGAGATGGG'
    Select @read_str='AACACCCAAAGACACACGTGACCCACCATCCCGTCTCTGACCATGAGGCCACCCTGAGGTGCTGGGCCCTGGGCTTCTACCCTGCGGAGATCACACTGACCTGGCAGCGGGATGGCGAGGACCAAACTCAGGACACCGAGCTTGTGGAGACCAGGCCAGCAGGAGATGGAACCTTCCAGAAGTGGGCAGCTGTGGTGGTGCCTTCTGGAGAAGAGCAGAGATACACGTGCCATGTGCAGCACGAGGGGCTGCCAGAGCCCCTCACCCTGAGATGGG'
    Select @read_str='GCTCCCACTCCATGAAGTATTTCTTCACATCCGTGTCCCGGCCTGGCCGCGGAGAGCCCCGCTTCATCTCAGTGGGCTACGTGGACGACACGCAGTTCGTGCGGTTCGACAGCGACGCCGCGAGTCCGAGAGGGGAGCCGCGGGCGCCGTGGGTGGAGCAGGAGGGGCCGGAGTATTGGGACCGGGAGACACAGAAGTACAAGCGCCAGGCACAGACTGACCGAGTGAGCCTGCGGAACCTGCGCGGCTACTACAACCAGAGCGAGGCCG'


    Select 
           f.feature_name
          ,a.allele_name
          ,e.*
        From hla_uexon e With (Nolock)
            Inner Join dna2_hla.dbo.hla_features f With (Nolock) On f.feature_nucsequence = e.uexon_seq 
            Inner Join dna2_hla.dbo.[hla_alleles] a With (Nolock) On a.allele_id=f.allele_id And a.allele_name Like 'HLA-'+e.gen_cd+'%'
        Where 1=1
            And f.feature_name='Exon 2'
            -- and e.uexon_seq Like '%'+@read_str+'%'
            -- And e.uexon_iid=1659
            -- And a.allele_name Like '%HLA-C*01:02:01:01%'
            -- And a.hla_g_group Like '%C*03:04:01G%'
            And a.hla_g_group Like '%C*03:03:01G%'

    Select *
        from hla_fexon_align


    -- Кол-во уникальных экзонов по каждому типу гена с точностью до аллели
    -- в привязке к исходным данным
    Select Substring(a.allele_name,1,Charindex(':',a.allele_name))
            ,Count(*)
        From dna2_hla..hla_uexon e With (Nolock)
            Inner Join dna2_hla.dbo.hla_features f With (Nolock) On f.feature_nucsequence = e.uexon_seq
            Inner Join dna2_hla.dbo.[hla_alleles] a With (Nolock) On a.allele_id=f.allele_id
        Where 1=1
            and f.feature_name='Exon 2'
        Group by Substring(a.allele_name,1,Charindex(':',a.allele_name))
        Order By Substring(a.allele_name,1,Charindex(':',a.allele_name))

    -- Список уникльных экзонов
    -- обе половинки
	Select 
           e.gen_cd
          ,e.uexon_num
	      ,Len(uexon_seq)
          ,e.*
	    From dna2_hla.dbo.hla_uexon e
	    Where  1 = 1
	           --and e.uexon_half_iid=1
	           -- and e.k_forward_back=2
	           --and e.uexon_iid=17257
               --And e.uexon_len=293
               --And (
               --     (e.uexon_num In (2,3,4) And e.gen_cd In ('A','B','C')) 
               --     Or 
               --     (e.uexon_num In (2) And e.gen_cd In ('DRB1','DQB1','DPB1'))
               -- )
	    Order By e.gen_cd
                ,e.uexon_num
                ,e.uexon_half_iid
                ,e.uexon_iid
             --   ,e.uexon_seq
	            --,e.uexon_len_x
	            --,Len(uexon_seq)
	            --,uexon_name

    -- Кол-во уникальных экзонов по генам, типам и длине
	Select 
           e.gen_cd
          ,e.uexon_num
	      ,Len(uexon_seq)
          ,Count(*)/2
	    From dna2_hla.dbo.hla_uexon e
	    Where  1 = 1
	           --and e.uexon_half_iid=1
	           --and e.k_forward_back=1
	           --and e.uexon_iid=17257
               And (
                    (e.uexon_num In (2,3,4) And e.gen_cd In ('A','B','C')) 
                    Or 
                    (e.uexon_num In (2) And e.gen_cd In ('DRB1','DQB1','DPB1'))
                )
	    Group By
            e.gen_cd
            ,e.uexon_num
            ,Len(e.uexon_seq)
        Order By             
            e.gen_cd
            ,e.uexon_num
            ,Len(e.uexon_seq)

    -- Список экзонов, у котрых есть соответствия в другом гене
    Select a.allele_name
            ,f.*
        From dna2_hla.dbo.hla_features f With (Nolock) 
        Inner Join dna2_hla.dbo.[hla_alleles] a With (Nolock) On a.allele_id=f.allele_id
        Where f.feature_nucsequence In (
	        Select e.uexon_seq
	            From dna2_hla.dbo.hla_uexon e
	            Where  1 = 1
                       And (
                            (e.uexon_num In (2,3,4) And e.gen_cd In ('A','B','C')) 
                            Or 
                            (e.uexon_num In (2) And e.gen_cd In ('DRB1','DQB1','DPB1'))
                        )
	            Group By e.uexon_seq
                Having count(*)>1
        )
        Order by a.allele_name



    Select Count(*) From dna2_hla.dbo.hla_uexon_part

    -- Выравнивание экзонов
    Select *
        From hla_fexon_align

    Select ue.*
            ,ea.exon_seq
        From dna2_hla.dbo.hla_uexon ue
        Inner Join hla_fexon_align ea With (Nolock) On ea.gen_cd=ue.gen_cd And ea.exon_num=ue.uexon_num
        Where 1=1
            and ue.k_forward_back   = 1
            And Isnull(uexon_diff_seq,'')<>''
            and ue.gen_cd='A'
            and ue.uexon_num=2
        Order By ue.gen_cd
            ,ue.uexon_num
            ,ue.uexon_seq


    -- Список частей экзонов
    Select ep.*
            ,ue.uexon_seq
        from hla_uexon_part2 ep
        inner join hla_uexon ue on ue.uexon_iid=ep.uexon_iid
        where ep.uexon_iid<10
        order by ep.uexon_iid,ep.epart_pos
 
    Select Count(*) 
        From dna2_hla..hla_uexon_part
    Select Count(*) 
        From dna2_hla..hla_uexon_part2
 
    -- Уникальные части экзонов
    Select Count(*) 
        From dna2_hla.dbo.hla_uexon_upart
    Select Top 1000 *
        From dna2_hla.dbo.hla_uexon_upart
 
 
    -- ****************************************************************************************************
    -- Чтения
    -- ****************************************************************************************************
    Use dna2_fastq
    Go 

    -- Исходные риды
    Select Top 1000 *
        from hla_reads rd
        Where 1=1
            And rd.read_len<=140
        Order By rd.read_cd

    Select Count(*)
        From hla_reads r

    Select sum(r.read_len-11)
        From hla_reads r
 
    -- ==================================================
    -- K-mers read
    -- ==================================================
    Select Count(*) 
        From hla_reads_part

    Select Top 1000 
            rp.*
            ,rd.read_seq
        From hla_reads_part rp
        Inner Join hla_reads rd On rd.read_iid=rp.read_iid
        Order By rp.read_iid, rp.rpart_pos
 
    Select Distinct     
        rp.rpart_hash
        From hla_reads_part rp With (Nolock)
 
    -- ==================================================
    -- Уникальные вхождения в hla_reads_part
    -- ==================================================
    Select Count(*)
            , p.rpart_hash
        From hla_reads_part p
        Group By p.rpart_hash
        Order By  Count(*)

    Select up.*
        From hla_reads_upart up
        Order By up.urpart_cnt 
 
    -- Статистика вхождений
    Select up.urpart_cnt
        ,k_mer_scnt = Count(*)
        ,k_mer_scnt = Count(*)*urpart_cnt
        From hla_reads_upart up
        Group By up.urpart_cnt
        Order By up.urpart_cnt

    Select Sum(urpart_cnt)
        From hla_reads_upart up
        Where urpart_cnt<6


    -- ****************************************************************************************************
    -- Сравнение чтений и экзонов
    -- ****************************************************************************************************
    -- ==================================================
	-- cross таблица
    -- ==================================================
    Select Top 1000 
            pc.* 
            ,ue.k_forward_back
            ,ue.*
        From hla_join pc
        inner join dna2_hla.dbo.hla_uexon ue With (Nolock)On ue.uexon_iid=pc.uexon_iid

    Select Count(*) from hla_join
    -- Всего ридов нашлось
    Select Count(*)
        From ( Select Distinct read_iid
                   From hla_join ) As t
    
    -- Части экзона
    Select ep.*
        From dna2_hla.dbo.hla_uexon ue
        Inner Join dna2_hla.dbo.hla_uexon_part ep With (Nolock)
               On ep.uexon_iid = ue.uexon_iid
        Where  ue.uexon_iid = 1411
        Order By ep.epart_pos

    -- Части рида
    Select rp.*
          ,wr.read_seq
        From hla_reads wr
        Inner Join hla_reads_part rp With (Nolock)
               On rp.read_iid = wr.read_iid
        Where  wr.read_iid = 16743
        Order By rp.rpart_pos 

    -- Совпадение с 1411 экзоном b 
    Select rp.rpart_hash
          ,ep.epart_hash
          ,rp.rpart_pos
          ,ep.epart_pos
          ,ue.uexon_seq
          ,r.read_seq
        From dna2_hla.dbo.hla_uexon ue
        Inner Join dna2_hla.dbo.hla_uexon_part ep With (Nolock)
               On ep.uexon_iid = ue.uexon_iid
        Inner Join hla_reads_part rp With (Nolock)
               On rp.read_iid = 16743
              And rp.rpart_hash = ep.epart_hash
        Inner Join hla_reads r With (Nolock)
               On rp.read_iid = r.read_iid
        Where ue.uexon_iid = 1411
        Order By ep.epart_pos

    -- **************************************************
	-- hla_join_max таблица
    -- **************************************************
	Select count(*) from hla_join_max
	Select top 1000 * 
        from hla_join_max
        Order By uexon_iid

    Select Distinct read_iid
        from hla_join_max

    -- Список прямых/обратных ридов    
    Select distinct
            rm.read_iid
        From hla_join_max rm
            Inner Join dna2_hla.dbo.hla_uexon ue With (Nolock) On ue.uexon_iid = rm.uexon_iid -- And ue.k_forward_back=2
        Where 1=1
            And ue.k_forward_back=2

    Select rm.*
            ,ue.k_forward_back
        From hla_join_max rm
            Inner Join dna2_hla.dbo.hla_uexon ue With (Nolock) On ue.uexon_iid = rm.uexon_iid -- And ue.k_forward_back=2
        Where 1=1
            And rm.k_forward_back=2

    -- Есть ли риды, похожие на прямые и обратные экзоны
    ;With _cte_read As (
        Select distinct
                rm.read_iid
            From hla_join_max rm
                Inner Join dna2_hla.dbo.hla_uexon ue With (Nolock) On ue.uexon_iid = rm.uexon_iid 
            Where 1=1
                And rm.k_forward_back=1)
    Select distinct
            rm.read_iid
        From hla_join_max rm
            Inner Join dna2_hla.dbo.hla_uexon ue With (Nolock) On ue.uexon_iid = rm.uexon_iid 
        Where 1=1
            And rm.k_forward_back=2
            And rm.read_iid In (Select read_iid From _cte_read)

    -- **************************************************
    -- Расчет расстояния
    -- **************************************************
    Update hla_join_max
        Set seq_distance = dbo.sql_str_distance_cnt_from_point(wr.read_seq,ue.uexon_seq, rm.rpart_pos_1,rm.epart_pos_1)
        From hla_join_max rm
            Inner Join hla_reads wr With (Nolock) On wr.read_iid=rm.read_iid
            Inner Join dna2_hla.dbo.hla_uexon ue With (Nolock) On ue.uexon_iid = rm.uexon_iid -- And ue.k_forward_back=2
            Inner Join dna2_hla.dbo.hla_features f With (Nolock) On f.feature_nucsequence=ue.uexon_seq
            Inner Join dna2_hla.dbo.hla_alleles a With (Nolock) On a.allele_id=f.allele_id
        Where 1=1
            -- and ue.epart_cnt>20
            And ue.uexon_name='Exon 2'
            And a.allele_name Like '%DQB%'
            And rm.uexon_iid In (1111000278,597)

    Select a.allele_name
            ,rm.read_iid
            ,ue.uexon_iid
            ,distance = dbo.sql_str_distance_sdiff_from_point(wr.read_seq,ue.uexon_seq, rm.rpart_pos_1+12,rm.epart_pos_1+12)
        From hla_join_max rm
            Inner Join hla_reads wr With (Nolock) On wr.read_iid=rm.read_iid
            Inner Join dna2_hla.dbo.hla_uexon ue With (Nolock) On ue.uexon_iid = rm.uexon_iid -- And ue.k_forward_back=2
            Inner Join dna2_hla.dbo.hla_features f With (Nolock) On f.feature_nucsequence=ue.uexon_seq
            Inner Join dna2_hla.dbo.hla_alleles a With (Nolock) On a.allele_id=f.allele_id
        Where 1=1
            -- and ue.epart_cnt>20
            and rm.read_iid=2421
            And rm.uexon_iid In (3944,3877,3864)
        
	-- Расчет Diff
    Select   a.allele_name
            ,uexon_iid        = ue.uexon_iid
            ,rm.read_iid
            ,rm.seq_distance
            ,dbo.sql_str_distance_sdiff_from_point(wr.read_seq,ue.uexon_seq, rm.rpart_pos_1,rm.epart_pos_1)
            ,rm.rpart_pos_1
            ,rm.epart_pos_1
            ,rm.eq_cnt
            ,wr.read_seq 
            ,ue.uexon_seq
        From hla_join_max rm
            Inner Join hla_reads wr With (Nolock) On wr.read_iid=rm.read_iid
            Inner Join dna2_hla.dbo.hla_uexon ue With (Nolock) On ue.uexon_iid = rm.uexon_iid -- And ue.k_forward_back=2
            Inner Join dna2_hla.dbo.hla_features f With (Nolock) On f.feature_nucsequence=ue.uexon_seq
            Inner Join dna2_hla.dbo.hla_alleles a With (Nolock) On a.allele_id=f.allele_id
        Where 1=1
            -- and ue.epart_cnt>20
            And ue.uexon_name='Exon 2'
            And a.allele_name Like '%DQB%'
            And rm.uexon_iid In (1111000278,597)
        Order By ue.uexon_iid,rm.read_iid

	-- Список ридов для уникальных экзонов по определенному гену
    Select  f.feature_name
            ,a.allele_name
            ,uexon_iid        = ue.uexon_iid
            ,rm.read_iid
            ,rm.seq_distance
            -- ,dbo.sql_str_distance_sdiff_from_point(wr.read_seq,ue.uexon_seq, rm.rpart_pos_1,rm.epart_pos_1)
            ,wr.read_seq 
            ,ue.uexon_seq
            ,rm.k_forward_back
        From hla_join_max rm
            Inner Join hla_reads wr With (Nolock) On wr.read_iid=rm.read_iid
            Inner Join dna2_hla.dbo.hla_uexon ue With (Nolock) On ue.uexon_iid = rm.uexon_iid -- And ue.k_forward_back=2
            Inner Join dna2_hla.dbo.hla_features f With (Nolock) On f.feature_nucsequence=ue.uexon_seq
            Inner Join dna2_hla.dbo.hla_alleles a With (Nolock) On a.allele_id=f.allele_id
        Where 1=1
            and ue.uexon_name='Exon 2'
            And a.allele_name Like 'HLA-A*%'
            -- And rm.uexon_iid In (1111000278,597)
        Order By rm.read_iid,ue.uexon_iid

    ;With _cte_reads As (
        Select Distinct 
                rm.read_iid
            From hla_join_max rm
                Inner Join hla_reads wr With (Nolock) On wr.read_iid=rm.read_iid
                Inner Join dna2_hla.dbo.hla_uexon ue With (Nolock) On ue.uexon_iid = rm.uexon_iid -- And ue.k_forward_back=2
                Inner Join dna2_hla.dbo.hla_features f With (Nolock) On f.feature_nucsequence=ue.uexon_seq
                Inner Join dna2_hla.dbo.hla_alleles a With (Nolock) On a.allele_id=f.allele_id
            Where 1=1
                and ue.uexon_name='Exon 2'
                And a.allele_name Like 'HLA-A*%'
        )
    Select Distinct
             ue.uexon_iid
            ,rm.read_iid
            ,rm.epart_pos_1
            ,rm.rpart_pos_1
            ,rm.k_forward_back
        From hla_join_max rm
            Inner Join hla_reads wr With (Nolock) On wr.read_iid=rm.read_iid
            Inner Join dna2_hla.dbo.hla_uexon ue With (Nolock) On ue.uexon_iid = rm.uexon_iid -- And ue.k_forward_back=2
            Inner Join dna2_hla.dbo.hla_features f With (Nolock) On f.feature_nucsequence=ue.uexon_seq
            Inner Join dna2_hla.dbo.hla_alleles a With (Nolock) On a.allele_id=f.allele_id
            Inner Join _cte_reads cr With (Nolock) On rm.read_iid=cr.read_iid
        Where 1=1
        Order By rm.read_iid,ue.uexon_iid


    -- Список ридов, похожих на 'Экзон N' и 'HLA-A*%'
    Select  Distinct
            rm.read_iid
            ,Substring(a.allele_name,1,Charindex('*',a.allele_name))
        From hla_join_max rm
            -- Inner Join hla_reads wr With (Nolock) On wr.read_iid=rm.read_iid
            Inner Join dna2_hla.dbo.hla_uexon ue With (Nolock) On ue.uexon_iid = rm.uexon_iid -- And ue.k_forward_back=2
            Inner Join dna2_hla.dbo.hla_features f With (Nolock) On f.feature_nucsequence=ue.uexon_seq
            Inner Join dna2_hla.dbo.hla_alleles a With (Nolock) On a.allele_id=f.allele_id
        Where 1=1
            -- and ue.uexon_name='Exon 3'
            And a.allele_name Like '%DPB%'
            -- And a.allele_name Like 'HLA-A*%'
            -- And a.allele_name Like '%DPB%'
        Order By rm.read_iid,Substring(a.allele_name,1,Charindex('*',a.allele_name))

    -- Кол-во ридов по генам и экзонам
    ;With _cte_rcnt As (
        Select  rm.read_iid
                ,gen_name=Substring(a.allele_name,1,Charindex('*',a.allele_name))
                ,ue.uexon_name
            From hla_join_max rm
                -- Inner Join hla_reads wr With (Nolock) On wr.read_iid=rm.read_iid
                Inner Join dna2_hla.dbo.hla_uexon ue With (Nolock) On ue.uexon_iid = rm.uexon_iid -- And ue.k_forward_back=2
                Inner Join dna2_hla.dbo.hla_features f With (Nolock) On f.feature_nucsequence=ue.uexon_seq
                Inner Join dna2_hla.dbo.hla_alleles a With (Nolock) On a.allele_id=f.allele_id
            Where 1=1
                -- and ue.uexon_name='Exon 3'
                -- And a.allele_name Like '%DPB%'
                -- And a.allele_name Like 'HLA-A*%'
                -- And a.allele_name Like '%DPB%'
            Group By rm.read_iid,Substring(a.allele_name,1,Charindex('*',a.allele_name)),ue.uexon_name
        )
    Select read_cnt=Count(*)
           ,gen_name
        From _cte_rcnt           
        Group By gen_name,uexon_name
        Order By gen_name,uexon_name


    -- Проверка кластеризации по hla_join
    -- выделим риды, одновременно похожие на разные экзоны или гены
    ;With _cte_uread As (
        Select  Distinct
                rm.read_iid
                ,ue.gen_cd
                ,ue.uexon_num
            From hla_join rm
                Inner Join dna2_hla.dbo.hla_uexon ue With (Nolock) On ue.uexon_iid = rm.uexon_iid -- And ue.k_forward_back=2
            Where (
                    (ue.gen_cd In ('A','B','C') and ue.uexon_num In (2,3,4)
                    Or 
                    (ue.gen_cd In ('DRB1','DQB1','DPB1') and ue.uexon_num In (2))
                    )
                  )
        )
    Select *
        From _cte_uread t1
        Inner Join _cte_uread t2 On t1.read_iid=t2.read_iid And (t1.gen_cd<>t2.gen_cd Or t1.uexon_num<>t2.uexon_num)
        Order By t1.gen_cd,t1.uexon_num,t1.read_iid

    -- Проверка кластеризации по hla_join_max
    -- выделим риды, одновременно похожие на разные экзоны или гены
    ;With _cte_uread As (
        Select  Distinct
                rm.read_iid
                ,ue.gen_cd
                ,ue.uexon_num
            From hla_join_max rm
                Inner Join dna2_hla.dbo.hla_uexon ue With (Nolock) On ue.uexon_iid = rm.uexon_iid -- And ue.k_forward_back=2
            Where (
                    (ue.gen_cd In ('A','B','C') and ue.uexon_num In (2,3,4)
                    Or 
                    (ue.gen_cd In ('DRB1','DQB1','DPB1') and ue.uexon_num In (2))
                    )
                  )
        )
    Select *
        From _cte_uread t1
        Inner Join _cte_uread t2 On t1.read_iid=t2.read_iid And (t1.gen_cd<>t2.gen_cd Or t1.uexon_num<>t2.uexon_num)
        Order By t1.gen_cd,t1.uexon_num,t1.read_iid


    -- ****************************************************************************************************
    -- Алгоритм выравнивания ридов
    -- Выбираем таблицу ридов по каждому гену и экзону
    -- Выбираем таблицу первых аллелей-экзонов для первых записей XXX*01:01:01. Только для тех, которые встретились в ридах
    -- ****************************************************************************************************
    Declare @row_num2       Int
            ,@all_name      varchar(50)
            ,@exon_name     varchar(50)
            ,@exon_num      Int
            ,@gen_cd        Varchar(20)
            ,@exon_seq      Varchar(Max)
            ,@fexon_iid     Int
            ,@exon_len      Int

    -- Таблица результата
    If Object_id('hla_reads_align') Is Not null
        Drop table hla_reads_align
    Create Table [dbo].hla_reads_align
    (
	    [ralign_iid]					numeric(15) Not Null Identity (1,1)
	   ,[read_iid]				        Int
       ,[gen_cd]                        varchar(10)             -- код гена HLA-A*, HLA-B*, HLA-C* ... 
	   ,[uexon_num]	    				numeric(2)              -- Номер экзона
       ,[read_diff_seq]                 varchar(max)    Null    -- 
    )
    Create Nonclustered Index [hla_reads_align_idx1] On [dbo].[hla_reads_align](gen_cd,uexon_num)
    Create Nonclustered Index [hla_reads_align_idx2] On [dbo].[hla_reads_align](read_iid,gen_cd,uexon_num)

    -- Временные таблицы
    If Object_id('tempdb..#read_gen_lst') Is Not Null
        drop Table #read_gen_lst
    If Object_id('tempdb..#exon_read_lst2') Is Not Null
        drop Table #exon_read_lst2
    If Object_id('tempdb..#exon_read_lst') Is Not Null
        drop Table #exon_read_lst
    If Object_id('tempdb..#alg_result') Is Not Null
        drop Table #alg_result

    Print '=================================================='
    Print '*** Выравнивание ридов на первые аллели для каждого гена'

    -- ==================================================
    -- Цикл по родительским экзонам
    -- ==================================================
    -- Select * From [hla_fexon_align]
    Select @fexon_iid=Min(fexon_iid)
        From dna2_hla.dbo.hla_fexon_align

    While Isnull(@fexon_iid,0)<>0
    Begin
        Select @all_name    = t.allele_name
              ,@exon_num    = t.exon_num
              ,@exon_seq    = t.exon_seq
              ,@gen_cd      = t.gen_cd
              ,@exon_len    = t.exon_len
            From dna2_hla.dbo.[hla_fexon_align] t
            Where fexon_iid=@fexon_iid


        Print '=================================================='
        Print '*** Выравнивание all_name='+@all_name+' exon_num='+cast(@exon_num As Varchar(2))+' exon_seq='+@exon_seq

        -- Список ридов для данного экзона и гена
        Insert hla_reads_align (
	            [read_iid]				        
               ,[gen_cd] 
	           ,[uexon_num]	  )
            Select Distinct 
                    rm.read_iid
                    , @gen_cd
                    , @exon_num
                From hla_join_max rm
                    Inner Join hla_reads wr With (Nolock) On wr.read_iid=rm.read_iid
                    Inner Join dna2_hla.dbo.hla_uexon ue With (Nolock) On ue.uexon_iid = rm.uexon_iid -- And ue.k_forward_back=2
                Where 1=1
                    And ue.gen_cd       = @gen_cd
                    And ue.uexon_num    = @exon_num

        Update hla_reads_align
        	Set [read_diff_seq] = dbo.sql_str_rank_sdiff(wr.read_seq ,@exon_seq)
        	From hla_reads wr With (Nolock)
            Inner Join hla_reads_align ra With (Nolock)  
                On ra.read_iid = wr.read_iid  
                And ra.gen_cd = @gen_cd  
                And ra.uexon_num = @exon_num

    	-- Продолжить цикл
        Select @fexon_iid=Min(fexon_iid)
            From dna2_hla.dbo.[hla_fexon_align]
            Where fexon_iid>@fexon_iid

    End

    -- ==================================================
    -- Список ридов
    -- ==================================================
    Select *
        From hla_reads_align ra With (Nolock)
        Where ra.gen_cd='DQB1'
        And ra.uexon_num=2
        Order By ra.read_diff_seq 

	-- Кол-во ридов по генам и экзонам
    Select ra.gen_cd, ra.uexon_num,  Count(*)
        From hla_reads_align ra With (Nolock)
        Group by ra.gen_cd, ra.uexon_num
		Order by gen_cd, ra.uexon_num

    -- ==================================================
	-- Распределение уникальных ридов в пределах экзона, гена	
    -- ==================================================
	Select Count(*)
			,ra.read_diff_seq 
		From hla_reads_align ra With (Nolock)
		Where ra.gen_cd='DQB1'
			And ra.uexon_num=2
		Group by ra.read_diff_seq 
		Order By Count(*),ra.read_diff_seq 

    Select Count(*)
            ,substring(ra.read_diff_seq ,1,270)
        From hla_reads_align ra With (Nolock)
        Where ra.gen_cd='DQB1'
        Group by substring(ra.read_diff_seq ,1,270)
        Order By Count(*),substring(ra.read_diff_seq ,1,270)


    -- Список экзонов
    Select a.allele_name
            ,a.hla_g_group
            ,f.feature_name
            ,f.feature_nucsequence
            ,f.*
        From [dna2_hla].[dbo].hla_features f with (NoLock) 
		Inner Join dna2_hla.dbo.hla_alleles a with (NoLock) On a.allele_id=f.allele_id 
        Inner Join dna2_hla.dbo.hla_uexon ue With (Nolock) On ue.uexon_seq=f.feature_nucsequence And ue.k_forward_back=1
        Where 1=1
            --And ue.uexon_diff_seq Like '--------C-T-T-----------------------------------------------------------------------------T-------------------------------------------------------------------------------------------------------------------------A-G----------------------G--%'
             -- And a.hla_g_group='DQB1*03:01:01G'
             -- And f.feature_name='exon 2'
        Order by f.feature_name
                ,a.allele_name
                ,f.feature_nucsequence

    -- ==================================================
	-- Количество точных совпадений DIFF
	-- Для одного экзона
    -- ==================================================
    Select Count(*)
            ,ue.gen_cd
            ,ue.uexon_num
            ,a.allele_name
            ,a.hla_g_group
            ,f.feature_name
            ,Substring(ra.read_diff_seq,1,Len(ue.uexon_diff_seq))
        From dna2_hla.dbo.hla_uexon ue
        Inner Join dna2_hla.dbo.hla_features f On f.feature_nucsequence = ue.uexon_seq
        Inner Join dna2_hla.dbo.hla_alleles a On a.allele_id = f.allele_id
        Inner Join hla_reads_align ra With (Nolock) 
                On ra.gen_cd=ue.gen_cd  
                    and ra.uexon_num=ue.uexon_num
                    and Substring(ra.read_diff_seq,1,Len(ue.uexon_diff_seq))=ue.uexon_diff_seq
        Where 1=1
			-- and ra.gen_cd='C'
			-- and ra.gen_cd='DQB1'
			-- And ra.uexon_num=2
			-- And a.allele_name Like 'HLA-C%'
        Group by ue.gen_cd
                ,ue.uexon_num
                ,a.hla_g_group
                ,a.allele_name
                ,f.feature_name
                ,Substring(ra.read_diff_seq,1,Len(ue.uexon_diff_seq))
        Order By ue.gen_cd
                ,ue.uexon_num
                ,a.hla_g_group
                ,a.allele_name
                ,f.feature_name
                ,Count(*)
                ,Substring(ra.read_diff_seq,1,Len(ue.uexon_diff_seq))

    Select *    
        From hla_reads_align a
        Where a.read_diff_seq Like '------------------------C------------------------G------------.-0-----C----3-.---------------G---.-0--CA-------------------A--T--A--------------C--------C-----A---------------------------.-2------------CC-------A-T------C-------------------------------------------------%'

    Select *
        From hla_reads
        Where read_iid=103303

    Select *
        From dna2_hla.dbo.hla_fexon_align

    -- ==================================================
	-- Количество точных совпадений DIFF
	-- Для одного гена
    -- ==================================================
    Declare 
		@gen_cd	Varchar(10)
	Select @gen_cd='C'
	    		 
    ;with _cte_2 As (Select
						 ue.gen_cd
						,ue.uexon_num
						,a.allele_name
						,a.hla_g_group
					From dna2_hla.dbo.hla_uexon ue
					Inner Join dna2_hla.dbo.hla_features f On f.feature_nucsequence = ue.uexon_seq
					Inner Join dna2_hla.dbo.hla_alleles a On a.allele_id = f.allele_id
					Inner Join hla_reads_align ra With (Nolock) 
							On ra.gen_cd=ue.gen_cd  
								and ra.uexon_num=ue.uexon_num
								and Substring(ra.read_diff_seq,1,Len(ue.uexon_diff_seq))=ue.uexon_diff_seq
					Where 1=1
						and ra.gen_cd=@gen_cd
						And ra.uexon_num=2
						And a.allele_name Like 'HLA-'+@gen_cd+'%'
					Group By ue.gen_cd,ue.uexon_num,a.allele_name,a.hla_g_group
					Having Count(*)>10
		) 							
		,_cte_3 As (Select
						 ue.gen_cd
						,ue.uexon_num
						,a.allele_name
						,a.hla_g_group
					From dna2_hla.dbo.hla_uexon ue
					Inner Join dna2_hla.dbo.hla_features f On f.feature_nucsequence = ue.uexon_seq
					Inner Join dna2_hla.dbo.hla_alleles a On a.allele_id = f.allele_id
					Inner Join hla_reads_align ra With (Nolock) 
							On ra.gen_cd=ue.gen_cd  
								and ra.uexon_num=ue.uexon_num
								and Substring(ra.read_diff_seq,1,Len(ue.uexon_diff_seq))=ue.uexon_diff_seq
					Where 1=1
						and ra.gen_cd=@gen_cd
						And ra.uexon_num=3
						And a.allele_name Like 'HLA-'+@gen_cd+'%'
					Group By ue.gen_cd,ue.uexon_num,a.allele_name,a.hla_g_group
					Having Count(*)>10
		)
		,_cte_4 As (Select
						 ue.gen_cd
						,ue.uexon_num
						,a.allele_name
						,a.hla_g_group
					From dna2_hla.dbo.hla_uexon ue
					Inner Join dna2_hla.dbo.hla_features f On f.feature_nucsequence = ue.uexon_seq
					Inner Join dna2_hla.dbo.hla_alleles a On a.allele_id = f.allele_id
					Inner Join hla_reads_align ra With (Nolock) 
							On ra.gen_cd=ue.gen_cd  
								and ra.uexon_num=ue.uexon_num
								and Substring(ra.read_diff_seq,1,Len(ue.uexon_diff_seq))=ue.uexon_diff_seq
					Where 1=1
						and ra.gen_cd=@gen_cd
						And ra.uexon_num=4
						And a.allele_name Like 'HLA-'+@gen_cd+'%'
					Group By ue.gen_cd,ue.uexon_num,a.allele_name,a.hla_g_group
					Having Count(*)>10
		)
		Select   c2.gen_cd
				,c2.uexon_num
				,c2.allele_name
				,c2.hla_g_group
			From _cte_2 c2 
				inner join _cte_3 c3 On c3.allele_name=c2.allele_name
				inner join _cte_4 c4 On c4.allele_name=c2.allele_name
			Group By c2.gen_cd,c2.uexon_num,c2.hla_g_group,c2.allele_name
		    Order By c2.gen_cd
					,c2.uexon_num
					,c2.hla_g_group
					,c2.allele_name



    -- ****************************************************************************************************
    -- Алгоритм усреднения 2
    -- ****************************************************************************************************
    Declare @n1 Int
            ,@cnt_all   Numeric(7,2)
            ,@max_len   Int
            ,@level     Numeric(5,2)
            ,@all_Like  Varchar(20)
            ,@char_cnt  int
            ,@char_cnt2 int
            ,@char_val  varchar(1)
            ,@k_loop    int

    Declare @row_num2       Int
            ,@all_name      varchar(50)
            ,@exon_name     varchar(50)
            ,@exon_num      Int
            ,@gen_cd        Varchar(20)
            ,@exon_seq      Varchar(Max)
            ,@fexon_iid     Numeric(14)
            ,@exon_len      Int

    Select @level=0.1

    -- Временные таблицы
    If Object_id('tempdb..#res_diff') Is Not Null
        drop Table #res_diff
    If Object_id('tempdb..#col_chars') Is Not Null
        drop Table #col_chars

    Create table #col_chars (
        curr_char   Varchar(1)
        ,char_cnt   int
        ,char_rate  Numeric(7,2)
    )

    -- ==================================================
    -- Цикл по родительским экзонам
    -- ==================================================
    -- Select * From [hla_fexon_align]

    Select @fexon_iid=Min(al.fexon_iid)
        From dna2_hla.dbo.hla_fexon_align al


    While Isnull(@fexon_iid,0)<>0
    Begin
        Select @all_name    = t.allele_name
              ,@exon_num    = t.exon_num
              ,@exon_seq    = t.exon_seq
              ,@gen_cd      = t.gen_cd
              ,@exon_len    = t.exon_len
            From dna2_hla.dbo.[hla_fexon_align] t
            Where fexon_iid=@fexon_iid


        Print '=================================================='
        Print '*** Усреднение all_name='+@all_name+' exon_num='+cast(@exon_num As Varchar(2))+' exon_seq='+@exon_seq

        -- ==================================================
        -- Цикл по символам - обработка вставок и удалений
        -- ==================================================
        Select @n1      = 1
        Select @max_len = Max(Len(ra.read_diff_seq)) 
             , @cnt_all = Count(*) 
            From hla_reads_align ra
            Where ra.uexon_num=@exon_num
                And ra.gen_cd=@gen_cd
        While @n1<=@max_len
        Begin
            

            Select @k_loop=0
            Delete from #col_chars
            Insert #col_chars
    	        Select curr_char    = Substring(read_diff_seq ,@n1,1)
                        ,char_cnt   = Count(*)
                        ,char_rate  = Count(*)/@cnt_all
                    From hla_reads_align ra
                    Where ra.uexon_num=@exon_num
                        And ra.gen_cd=@gen_cd
                    Group By Substring(ra.read_diff_seq,@n1,1)
            Select @char_cnt2=@@rowcount
            If @char_cnt2=0
            Begin
                Break
            End
            Select @k_loop=isNull(Count(*),0)
                From #col_chars
                where curr_char In ('0','1','2','3') 

            --Print 'gn_cd='+@gen_cd
            --        +'  @exon_num='+Cast(@exon_num As Varchar(20))
            --        +'  @step='+Cast(@n1 As Varchar(20))
            --        +'  @k_loop='+Cast(@k_loop As Varchar(20))
            --        +'  @max_len='+Cast(@max_len As Varchar(20))
            --        +'  @@rowcount='+Cast(@char_cnt2 As Varchar(20))

            If @k_loop>0
            Begin

                Select @char_cnt=Count(*) 
                    From #col_chars
                    where char_rate>=@level
                Select @char_val=curr_char
                    From #col_chars
                    where char_rate>=@level

                Update hla_reads_align
                    Set read_diff_seq=STUFF(
                              read_diff_seq
                            , @n1
                            , 1
                            , Case 
                                -- Это вставка в шаблон - считаем, что в риде лишний символ 
                                When ct.curr_char In ('0','1','2','3') 
                                    And char_rate<@level 
                                    And @char_cnt=1 
                                    And @char_val not In ('0','1','2','3') Then ''
                                -- Это символ - просто символ
                                When ct.curr_char='0' Then 'a'
                                When ct.curr_char='1' Then 'c'
                                When ct.curr_char='2' Then 'g'
                                When ct.curr_char='3' Then 't'
                                Else ct.curr_char
                            End
                            )
                    From hla_reads_align ra With (Nolock)
                    Inner Join #col_chars ct On ct.curr_char=Substring(ra.read_diff_seq ,@n1,1)
                    where Len(read_diff_seq)>=@n1
                        And ra.uexon_num=@exon_num
                        And ra.gen_cd=@gen_cd
                        And (      (ct.curr_char<>@char_val And @char_cnt=1) 
                                Or (ct.curr_char In ('0','1','2','3') And @char_cnt=1) 
                                Or @char_cnt>1 
                                )

            End Else
            Begin

                Select @char_cnt=Count(*) 
                    From #col_chars
                    where char_rate>=@level
                Select @char_val=curr_char
                    From #col_chars
                    where char_rate>=@level

                Update hla_reads_align
                    Set read_diff_seq=STUFF(
                                read_diff_seq
                            , @n1
                            , 1
                            , Case 
                                When ct.curr_char='.' And char_rate<@level and @char_cnt=1 Then @char_val
                                When ct.curr_char='.' And char_rate<@level and @char_cnt>1 Then '?'
                                When ct.curr_char Not In ('.','^','-') and @char_cnt=1 and char_rate<@level Then @char_val
                                When ct.curr_char Not In ('.','^','-') and @char_cnt>1 and char_rate<@level Then '?'
                                Else ct.curr_char
                            End
                            )
                    From hla_reads_align ra With (Nolock)
                    Inner Join #col_chars ct On ct.curr_char=Substring(ra.read_diff_seq ,@n1,1)
                    where Len(read_diff_seq)>=@n1
                        And ra.uexon_num=@exon_num
                        And ra.gen_cd=@gen_cd
                        And ( (ct.curr_char<>@char_val And @char_cnt=1) Or @char_cnt>1 )
                Select @n1=@n1+1
            End
        End

    	-- Продолжить цикл
        Select @fexon_iid=Min(fexon_iid)
            From dna2_hla.dbo.[hla_fexon_align]
            Where fexon_iid>@fexon_iid

    End

    -- ==================================================
    -- Обработка ?
    -- ==================================================
    Declare @seq_str    Varchar(Max)
            ,@main_pos   Int
            ,@beg_pos   Int
            ,@end_pos   Int
            ,@read_iid  Int
            ,@mask      varchar(50)
            ,@mask_val  varchar(50)
            ,@mask_cnt  int

    If Object_id('tempdb..#mask') Is Not Null
        drop Table #mask
    Create table #mask (
        mask_val   Varchar(50)
    )

    While 1=1
    Begin
    	Select top 1 
                 @seq_str    = read_diff_seq
                ,@main_pos  = Charindex('?',read_diff_seq)
                ,@read_iid  = read_iid
            From hla_reads_align
            Where Charindex('?',read_diff_seq)>0
        If @@rowcount=0 Break;

        Select @beg_pos = 1
        if @main_pos>6 Select @beg_pos=@main_pos-6
        Select @mask=Replace(Substring(@seq_str,@beg_pos,13),'?','_')


        Delete from #mask
        Insert #mask
            Select Substring(read_diff_seq,@beg_pos,13)
                From hla_reads_align
                Where Substring(read_diff_seq,@beg_pos,13) Like @mask
                    and Charindex('?',Substring(read_diff_seq,@beg_pos,13))=0
                Group By Substring(read_diff_seq,@beg_pos,13)
        Select @mask_cnt=Count(*) From #mask 

        -- Select @seq_str,@main_pos,@beg_pos,@mask,@mask_cnt

        If @mask_cnt=1 
        Begin
            Select @mask_val=substring(mask_val,7,1) From #mask
        	Update hla_reads_align
                Set read_diff_seq = Stuff(read_diff_seq,@main_pos,1,@mask_val)
                From hla_reads_align
                Where Substring(read_diff_seq,@beg_pos,13) Like @mask
                    and Substring(read_diff_seq,@main_pos,1)='?'
        End
        If @mask_cnt<>1 
        Begin
            Select @mask_val=mask_val From #mask
        	Update hla_reads_align
                Set read_diff_seq = Stuff(read_diff_seq,@main_pos,1,'$')
                Where read_iid=@read_iid
        End

    End


    Select *
         --,[02-01-01] = dbo.sql_str_rank_sdiff(read_seq_e,'AGAATTACCTTTTCCAGGGACGGCAGGAATGCTACGCGTTTAATGGGACACAGCGCTTCCTGGAGAGATACATCTACAACCGGGAGGAGTTCGTGCGCTTCGACAGCGACGTGGGGGAGTTCCGGGCGGTGACGGAGCTGGGGCGGCCTGATGAGGAGTACTGGAACAGCCAGAAGGACATCCTGGAGGAGGAGCGGGCAGTGCCGGACAGGATGTGCAGACACAACTACGAGCTGGGCGGGCCCATGACCCTGCAGCGCCGAG')
         --,[09-01-01] = dbo.sql_str_rank_sdiff(read_seq_e,'AGAATTACGTGCACCAGTTACGGCAGGAATGCTACGCGTTTAATGGGACACAGCGCTTCCTGGAGAGATACATCTACAACCGGGAGGAGTTCGTGCGCTTCGACAGCGACGTGGGGGAGTTCCGGGCGGTGACGGAGCTGGGGCGGCCTGATGAGGACTACTGGAACAGCCAGAAGGACATCCTGGAGGAGGAGCGGGCAGTGCCGGACAGGGTATGCAGACACAACTACGAGCTGGACGAGGCCGTGACCCTGCAGCGCCGAG')
        From #res_diff

    
    Select count(*)
            ,read_seq_res_diff
        From #res_diff
        Group By read_seq_res_diff
        Order By Count(*)

  




















    -- Список ридов, похожих на 'Экзон N' 
    Select  Distinct
            rm.read_iid
        From hla_join_max rm
            -- Inner Join hla_reads wr With (Nolock) On wr.read_iid=rm.read_iid
            Inner Join dna2_hla.dbo.hla_uexon ue With (Nolock) On ue.uexon_iid = rm.uexon_iid -- And ue.k_forward_back=2
            Inner Join dna2_hla.dbo.hla_features f With (Nolock) On f.feature_nucsequence=ue.uexon_seq
        Where 1=1
            and ue.uexon_name='Exon 3'
            -- And a.allele_name Like '%DPB%'
            -- And a.allele_name Like 'HLA-A*%'
        Order By rm.read_iid



	-- Количество совпавших ридов с каждым экзоном
    Select uexon_iid        = ue.uexon_iid
          ,uexon_name       = Max(ue.uexon_name)
          ,read_cnt         = count(*)          -- кол-во ридов в hla_join_max
        From hla_join_max rm
            Inner Join dna2_hla.dbo.hla_uexon ue With (Nolock) On ue.uexon_iid = rm.uexon_iid -- And ue.k_forward_back=2
        Where 1=1
            -- and ue.uexon_name='Exon 4'
        Group By ue.uexon_name,ue.uexon_iid
        Order By ue.uexon_name,read_cnt,ue.uexon_iid

    -- Список ридов для экзона
    Select *
        From dna2_hla.dbo.hla_uexon
        Where uexon_iid=17877

    Select rm.*, wr.read_seq, wr.read_seq
        From hla_join_max rm
            Inner Join hla_uexon ue With (Nolock) On ue.uexon_iid = rm.uexon_iid -- And ue.k_forward_back=2
            Inner Join hla_reads wr With (Nolock) On wr.read_iid=rm.read_iid
        Where 1=1
            And ue.uexon_name='Exon 2'
            And rm.uexon_iid=17877

	-- Список ридов для даного типа гена по "Exon N"
    Select allele_id        = f.allele_id
          ,allele_name      = a.allele_name
          ,hla_g_group		= a.hla_g_group
          ,uexon_iid        = ue.uexon_iid
          ,uexon_name       = ue.uexon_name
          ,wr.read_iid
        From hla_join_max rm
			inner join hla_reads wr with (NoLock) On wr.read_iid=rm.read_iid 
            Inner Join dna2_hla.dbo.hla_uexon ue With (Nolock) On ue.uexon_iid = rm.uexon_iid -- And ue.k_forward_back=2
            Inner Join dna2_hla.dbo.hla_features f With (Nolock) On f.feature_nucsequence=ue.uexon_seq
            Inner Join dna2_hla.dbo.hla_alleles a With (Nolock) On a.allele_id=f.allele_id
        Where 1=1
            And ue.uexon_name='Exon 2'
            -- And a.allele_name Like '%DQB%'
            And a.allele_name Like '%A*%'
        Order By a.allele_name,f.allele_id,ue.uexon_iid


    -- ==================================================
    -- Анализ аллелей
    -- ==================================================
    Declare @gen Varchar(20)
    Select @gen='%HLA-A*%'
    Select @gen='%HLA-B*%'
    Select @gen='%HLA-C*%'
    
    ;With _cte_2 As (
        Select allele_id    = f.allele_id
              ,allele_name  = max(a.allele_name)
            From hla_join_max rm
                Inner Join hla_uexon ue With (Nolock)  On ue.uexon_iid = rm.uexon_iid and ue.uexon_name='Exon 2'
                Inner Join hla_features f With (Nolock) On f.feature_nucsequence=ue.uexon_seq
                Inner Join hla_alleles a With (Nolock) On a.allele_id=f.allele_id
            Where a.allele_name Like @gen
            Group By f.allele_id
            )
    , _cte_3 As (
        Select allele_id    = f.allele_id
              ,allele_name  = max(a.allele_name)
            From hla_join_max rm
                Inner Join hla_uexon ue With (Nolock) On ue.uexon_iid=rm.uexon_iid And ue.uexon_name='Exon 3'
                Inner Join hla_features f With (Nolock) On f.feature_nucsequence=ue.uexon_seq
                Inner Join hla_alleles a With (Nolock) On a.allele_id=f.allele_id
            Where a.allele_name Like @gen
            Group By f.allele_id
            )
    , _cte_4 As (
        Select allele_id    = f.allele_id
              ,allele_name  = max(a.allele_name)
            From hla_join_max rm
                Inner Join hla_uexon ue With (Nolock) On ue.uexon_iid=rm.uexon_iid And ue.uexon_name='Exon 4'
                Inner Join hla_features f With (Nolock) On f.feature_nucsequence=ue.uexon_seq
                Inner Join hla_alleles a With (Nolock) On a.allele_id=f.allele_id
            Where a.allele_name Like @gen
            Group By f.allele_id
            )
    Select c2.allele_id
            , Count(*)
            , c2.allele_name
        From _cte_2 c2
            Inner Join _cte_3 c3 With (Nolock) On c2.allele_id=c3.allele_id
            Inner Join _cte_4 c4 With (Nolock) On c2.allele_id=c4.allele_id
            Inner Join hla_alleles a With (Nolock) On a.allele_id=c2.allele_id
        Group By c2.allele_id,c2.allele_name
        Order By c2.allele_name


/*


 -- ==================================================
 
 -- Всего rpart
 Select Count(*)
     from #part rp With (Nolock)
 
 -- Всего разных read_id
 Select Distinct rp.read_id
     from #part rp With (Nolock)
 
 Select top 1000 rp.*
     from #part rp With (Nolock)
     Order By rp.read_id,rp.rpart_pos
 
 -- Риды у котрых есть одинаковые rpart_seq
 Select -- Top 1000
        read_id      = rp.read_id
       ,rpart_pos    = rp.rpart_pos
       ,uexon_iid     = ep.uexon_iid
       ,epart_pos    = ep.epart_pos
       ,diff_pos     = rp.rpart_pos-ep.epart_pos 
       ,ep.epart_seq_x
       ,e.uexon_name
     from #part rp With (Nolock Index=tmp_part_idx3)
         Inner Join hla_uexon_part ep With (Nolock) On ep.epart_hash=rp.rpart_hash 
         Inner Join hla_uexon e With (Nolock) On ep.uexon_iid=e.uexon_iid
     Where 1=1
         --and rp.read_id In (0
         --    --,201671
         --    --,502204
         --    -- ,203988
         --    ,105252
         --    )
         --And ep.uexon_iid in (13280)
      Order By rp.read_id,ep.uexon_iid,rp.rpart_pos,ep.epart_pos
 
 /*
    Select *
        From hla_uexon
        Where uexon_iid In (12583,12585,12629,12927,12929,13648)
 
    Select *
        From hla_reads
        Where read_id=302114

     Select *
         From #part
         Where read_id=5913
         order by rpart_pos


    Select rpart_pos-28,rp.* , wm.*
        from #tread_part rp
            inner join hla_join_max wm on wm.wread_max_iid=rp.wread_max_iid
        where rp.wread_max_iid=1 
            and rp.read_id=5913 
        order by rp.rpart_pos

    Select ep.* , wm.*
        from #texon_part ep
            inner join hla_join_max wm on wm.wread_max_iid=ep.wread_max_iid
        where ep.wread_max_iid=1 
            and ep.uexon_iid=9356
        order by ep.epart_pos

    Select * From dna2_hla.dbo.hla_uexon Where uexon_half_iid In (6742)
    Select * From dna2_hla.dbo.hla_uexon Where uexon_iid In (21988)
    Select * From hla_reads Where read_iid=54
    -- wread_max_iid=18
    Select * 
        From hla_join_max rm
        inner join dna2_hla.dbo.hla_uexon e With (Nolock) on e.uexon_iid=rm.uexon_iid
        Where rm.wread_max_iid=18
            --read_iid=54 
            --and e.uexon_half_iid In (6742)
            --and e.uexon_iid=21988

-- Исходные перевернутые
e:CAGCCTCGCTCTGGTTGTAGCGGCGGAGCAGGTTCCTCAGGGCCACTCGGTCAGTCTGTGCGTTGGCCTTGGCGTACCCTGTGGTCCACTCCCAATACTGCGGCCCCTCTTGCTCCACCCACTGCTCCCGCGGCTCCATCCTCGGAATCGCGGCGTCGCTGTCGAACCGCAGGAATTGCGTGTCGTCTACGTACTCCACGGCGATGTAGCGGGGCTCCCCGCGGCCGGGCCGCGACACAGCGGTGCTGAAATACCTCAAGGAGTGGGAGC
r:CCCTGGCCGGGGTCACTCACCAGCCTCGCTCTGGTTGTAGCGGCGGAGCAGGTTCCTCAGGGCCACTCGGTCAGTCTGTGCGTTGGCCTTGGCGTACCCTGTTGTCCACTCCCAATACTGCGGCCCCTCTTGTTCCACCCACGGCTCCCGCGGCTCCATCCTCGGAATCGCGGCGTCGCTGTCGAACCGCAGGAATTGCGTGTCGTCTACGTACTCCACGGCGATGTAGCGGGGCTCCCCGCGGCCGGGCCGCGACACAGCGGTGCTGAGATACCTCAAGGAGTGGGAGCCTGGGGCGAGGAGGGGCTGAGACCTGCCCGACCCTCCTC
e:102113121313223323021221220210223311310222110131223102313232123322113322123011132322311013111003013212211113133213110111013213111212213110311312200312122123121323120011210220033212323123130123013110122120323021222213111121221122211212010102122321320003011310022023222021
r:11132211222231013101102113121313223323021221220210223311310222110131223102313232123322113322123011132332311013111003013212211113133233110111012213111212213110311312200312122123121323120011210220033212323123130123013110122120323021222213111121221122211212010102122321320203011310022023222021132222120220222213202011321112011131131

CCCTGGCCGGGGTCACTCACCAGCCTCGCTCTGGTTGTAGCGGCGGAGCAGGTTCCTCAGGGCCACTCGGTCAGTCTGTGCGTTGGCCTTGGCGTACCCTGTTGTCCACTCCCAATACTGCGGCCCCTCTTGTTCCACCCACGGCTCCCGCGGCTCCATCCTCGGAATCGCGGCGTCGCTGTCGAACCGCAGGAATTGCGTGTCGTCTACGTACTCCACGGCGATGTAGCGGGGCTCCCCGCGGCCGGGCCGCGACACAGCGGTGCTGAGATACCTCAAGGAGTGGGAGCCTGGGGCGAGGAGGGGCTGAGACCTGCCCGACCCTCCTC
GAGGAGGGTCGGGCAGGTCTCAGCCCCTCCTCGCCCCAGGCTCCCACTCCTTGAGGTATCTCAGCACCGCTGTGTCGCGGCCCGGCCGCGGGGAGCCCCGCTACATCGCCGTGGAGTACGTAGACGACACGCAATTCCTGCGGTTCGACAGCGACGCCGCGATTCCGAGGATGGAGCCGCGGGAGCCGTGGGTGGAACAAGAGGGGCCGCAGTATTGGGAGTGGACAACAGGGTACGCCAAGGCCAACGCACAGACTGACCGAGTGGCCCTGAGGAACCTGCTCCGCCGCTACAACCAGAGCGAGGCTGGTGAGTGACCCCGGCCAGGG

13113111021112311020231222202202122223112022232022001311030202312322120101021211222112212111131222212032302122101131032103132132321233002201211002132312132122121300221311301131221211131221011101133233131111221231030011131011323323111032122331122332123231320132213101122201311332201202212212032332231312131120110131013222211223111
20220222312221022313102111131131211110221311101311332022303131021011213232312122111221121222202111121301031211232202301230201201012100331132122331201021201211212033112022032202112122202112322232200100202222112102303322202322010010222301211002211001210102013201120232211132022001132131121121301001102021202213223202320111122110222

Вернули обратно
GCTCCCACTCCTTGAGGTATTTCAGCACCGCTGTGTCGCGGCCCGGCCGCGGGGAGCCCCGCTACATCGCCGTGGAGTACGTAGACGACACGCAATTCCTGCGGTTCGACAGCGACGCCGCGATTCCGAGGATGGAGCCGCGGGAGCAGTGGGTGGAGCAAGAGGGGCCGCAGTATTGGGAGTGGACCACAGGGTACGCCAAGGCCAACGCACAGACTGACCGAGTGGCCCTGAGGAACCTGCTCCGCCGCTACAACCAGAGCGAGGCTG
GAGGAGGGTCGGGCAGGTCTCAGCCCCTCCTCGCCCCAGGCTCCCACTCCTTGAGGTATCTCAGCACCGCTGTGTCGCGGCCCGGCCGCGGGGAGCCCCGCTACATCGCCGTGGAGTACGTAGACGACACGCAATTCCTGCGGTTCGACAGCGACGCCGCGATTCCGAGGATGGAGCCGCGGGAGCCGTGGGTGGAACAAGAGGGGCCGCAGTATTGGGAGTGGACAACAGGGTACGCCAAGGCCAACGCACAGACTGACCGAGTGGCCCTGAGGAACCTGCTCCGCCGCTACAACCAGAGCGAGGCTGGTGAGTGACCCCGGCCAGGG
e:213111013113320223033310210112132323121221112211212222021111213010312112322023012302012010121003311321223312010212012112120331120220322021121222021023222322021002022221121023033222023220110102223012110022110012101020132011202322111320220011321311211213010011020212022132
r:20220222312221022313102111131131211110221311101311332022303131021011213232312122111221121222202111121301031211232202301230201201012100331132122331201021201211212033112022032202112122202112322232200100202222112102303322202322010010222301211002211001210102013201120232211132022001132131121121301001102021202213223202320111122110222
 */
 
     -- ==================================================
     -- Количество совпадений каждого рида с экзонами
     -- ==================================================
     Select eq_cnt = Count(*)
           ,rp.read_id
           ,ep.uexon_iid
         Into #part_Cnt
         from #part rp With (Nolock Index=tmp_part_idx3)
             Inner Join hla_uexon_part ep With (Nolock) On ep.epart_hash=rp.rpart_hash 
             Inner Join hla_uexon e With (Nolock) On ep.uexon_iid=e.uexon_iid
             Inner Join hla_reads r With (Nolock) On r.read_id=rp.read_id
         Where 1=1
            and e.uexon_len_x<=r.read_len_x
            --and rp.read_id In (0
            --    --,201671
            --    --,502204
            --    -- ,203988
            --    ,600664
            --    )
          Group by rp.read_id,ep.uexon_iid
 
     Create Index tmp_part_cnt_idx1 On #part_cnt(read_id,uexon_iid)
     Create Index tmp_part_cnt_idx2 On #part_cnt(read_id,eq_cnt)
 

      Select top 1000 *
         from #part_cnt rp With (Nolock)
         order By rp.read_id, rp.uexon_iid

      Select count(*)
         from #part_cnt rp With (Nolock)

     -- Всего разных read
     Select Distinct rp.read_id
         from #part_cnt rp With (Nolock)
 

     Select eq_cnt=Max(t.eq_cnt)
             ,t.read_id
         Into #part_cnt_max
         From #part_cnt t With (Nolock)
         Group By t.read_id
 
     Create Index tmp_part_cnt_max_dx1 On #part_cnt_max(read_id)
 
    -- Записать результат в постоянную таблицу
    If Object_id('hla_join_max') Is Not null
         Drop table hla_join_max
    Create table hla_join_max (
            wread_max_iid   Numeric(15) Identity(1,1)
            ,read_id        Bigint
            ,uexon_iid      Int
            ,uexon_name     varchar(20) 
            ,eq_cnt         Int
        )

    Insert hla_join_max (
            read_id        
            ,uexon_iid      
            ,uexon_name    
            ,eq_cnt   )     
     Select pc.read_id        
            ,pc.uexon_iid      
            ,e.uexon_name    
            ,pc.eq_cnt        
         from #part_Cnt pc With (Nolock Index=tmp_part_cnt_idx2)
             Inner Join #part_cnt_max pm With (Nolock) On pc.read_id=pm.read_id And pc.eq_cnt=pm.eq_cnt
             Inner Join hla_uexon e With (Nolock) On pc.uexon_iid=e.uexon_iid
         Where 1=1
             -- and pc.eq_cnt>7
         Order By pc.read_id, pc.uexon_iid
 
    Create Index hla_wreads_max_idx1 On hla_join_max(read_id,uexon_iid)
    Create Index hla_wreads_max_idx2 On hla_join_max(read_id,wread_max_iid)
    Create Index hla_wreads_max_idx3 On hla_join_max(uexon_iid,wread_max_iid)
    Create Index hla_wreads_max_idx4 On hla_join_max(eq_cnt,wread_max_iid)

    Select Top 1000 * 
        From hla_join_max
 
 
    -- ==================================================
    -- Всего #part_Cnt
    Select Count(*)
        from #part_Cnt rp With (Nolock)
 
    Select Count(*)
        from #part_cnt_max rp With (Nolock)
 
    Select Count(*)
        From hla_join_max
 
    Select *
        from hla_join_max hw
        Where hw.eq_cnt>3
        order by uexon_iid,read_id
 
    Select uexon_name, count(*)
        from hla_join_max
        Where eq_cnt>3
        Group By uexon_name
        Order By uexon_name
 
    Select eq_cnt, count(*)
        from hla_join_max
        Group By eq_cnt
        Order By eq_cnt
 
 
    Select distinct pc.read_id
        from #part_Cnt pc With (Nolock Index=tmp_part_cnt_idx2)
            Inner Join #part_cnt_max pm With (Nolock) On pc.read_id=pm.read_id And pc.eq_cnt=pm.eq_cnt
            Inner Join hla_uexon e With (Nolock) On pc.uexon_iid=e.uexon_iid
        Where pc.eq_cnt>9
        Order By pc.read_id
 

    Select max(eq_cnt)
        From hla_join_max
 
    Select Distinct read_iid 
        From hla_join_max

    Select Distinct read_iid 
        From hla_reads
 
    -- ****************************************************************************************************
    -- Выравнивание
    -- ****************************************************************************************************
    Select top 100 *
        from hla_join_max
        Where uexon_iid=5250

    Select distinct read_iid,k_forward_back from hla_join_max

    Select distinct rm.read_iid,rm.k_forward_back 
        from hla_join_max rm
            Inner Join hla_uexon ue With (Nolock) On ue.uexon_iid = rm.uexon_iid 
        Where rm.k_forward_back=1

    Select read_cnt=Count(*)
          ,rm.uexon_iid
          ,uexon_name   = Max(ue.uexon_name)
          ,allele_id    = max(f.allele_id)
        From hla_join_max rm
            Inner Join hla_uexon ue With (Nolock) On ue.uexon_iid = rm.uexon_iid -- And ue.k_forward_back=2
            Inner Join hla_features f With (Nolock) On f.feature_nucsequence=ue.uexon_seq
        Group By rm.uexon_iid
        Order By read_cnt


    Select allele_id    = f.allele_id
          ,allele_name  = a.allele_name
          ,uexon_iid    = ue.uexon_iid
          ,uexon_name   = Max(ue.uexon_name)
          ,read_cnt     = Count(*)
        From hla_join_max rm
            Inner Join hla_uexon ue With (Nolock) On ue.uexon_iid = rm.uexon_iid -- And ue.k_forward_back=2
            Inner Join hla_features f With (Nolock) On f.feature_nucsequence=ue.uexon_seq
            Inner Join hla_alleles a With (Nolock) On a.allele_id=f.allele_id
        Where 1=1
            -- and ue.epart_cnt>20
            And ue.uexon_name='Exon 2'
        Group By a.allele_name,f.allele_id,ue.uexon_iid
        Order By a.allele_name,f.allele_id,ue.uexon_iid

        Для первого аллеля А 4тый экзон выравнивается на референс A*30:95_exon4, который отличается от A*11:01:01:01_exon4 одной заменой. Вследствие этого данный аллель определен только по 2му и 3му экзонам

    Select read_cnt=Count(*)
          ,rm.uexon_iid
          ,uexon_name   = Max(ue.uexon_name)
          ,allele_id    = max(f.allele_id)
        From hla_join_max rm
            Inner Join hla_uexon ue With (Nolock)
                   On ue.uexon_iid = rm.uexon_iid
                   And ue.uexon_name='Exon 2'
            Inner Join hla_features f With (Nolock) On f.feature_nucsequence=ue.uexon_seq
        Group By rm.uexon_iid
        Order By read_cnt

    Select read_cnt=Count(*)
          ,rm.uexon_iid
          ,uexon_name   = Max(ue.uexon_name)
          ,allele_id    = f.allele_id
        From hla_join_max rm
            Inner Join hla_uexon ue With (Nolock)
                   On ue.uexon_iid = rm.uexon_iid
                   And ue.uexon_name='Exon 2'
            Inner Join hla_features f With (Nolock) On f.feature_nucsequence=ue.uexon_seq
        Group By f.allele_id, rm.uexon_iid
        Order By f.allele_id, rm.uexon_iid, read_cnt



    ;With _cte_2 As (
        Select read_cnt=Count(*)
              ,uexon_iid    = rm.uexon_iid
              ,uexon_name   = Max(ue.uexon_name)
              ,allele_id    = f.allele_id
            From hla_join_max rm
                Inner Join hla_uexon ue With (Nolock)
                       On ue.uexon_iid = rm.uexon_iid
                       And ue.uexon_name='Exon 2'
                Inner Join hla_features f With (Nolock) On f.feature_nucsequence=ue.uexon_seq
            Group By f.allele_id,rm.uexon_iid
            )
    , _cte_3 As (
        Select read_cnt=Count(*)
              ,uexon_iid    = rm.uexon_iid
              ,uexon_name   = Max(ue.uexon_name)
              ,allele_id    = f.allele_id
            From hla_join_max rm
                Inner Join hla_uexon ue With (Nolock)
                       On ue.uexon_iid = rm.uexon_iid
                       And ue.uexon_name='Exon 3'
                Inner Join hla_features f With (Nolock) On f.feature_nucsequence=ue.uexon_seq
            Group By f.allele_id,rm.uexon_iid
            )
    , _cte_4 As (
        Select read_cnt=Count(*)
              ,uexon_iid    = rm.uexon_iid
              ,uexon_name   = Max(ue.uexon_name)
              ,allele_id    = f.allele_id
            From hla_join_max rm
                Inner Join hla_uexon ue With (Nolock)
                       On ue.uexon_iid = rm.uexon_iid
                       And ue.uexon_name='Exon 4'
                Inner Join hla_features f With (Nolock) On f.feature_nucsequence=ue.uexon_seq
            Group By f.allele_id,rm.uexon_iid
            )
    Select f.allele_id, Count(*), allele_name=Max(a.allele_name)
        From hla_join_max rm
            Inner Join hla_uexon ue With (Nolock)  On ue.uexon_iid=rm.uexon_iid
            Inner Join hla_features f With (Nolock) On f.feature_nucsequence=ue.uexon_seq
            Inner Join hla_alleles a With (Nolock) On a.allele_id=f.allele_id
        Where f.allele_id In (Select allele_id From _cte_2)
            And f.allele_id In (Select allele_id From _cte_3)
            And f.allele_id In (Select allele_id From _cte_4)
        Group By f.allele_id
        Order By allele_name,Count(*)

    Select rm.uexon_iid
          ,rm.eq_cnt
          ,uexon_name   = ue.uexon_name
          ,feature_name = f.feature_name
          ,allele_id    = f.allele_id
          ,read_iid     = rm.read_iid
        From hla_join_max rm
            Inner Join hla_uexon ue With (Nolock)
                   On ue.uexon_iid = rm.uexon_iid
                   -- And ue.uexon_name='Exon 2'
            Inner Join hla_features f With (Nolock) On f.feature_nucsequence=ue.uexon_seq
        Where f.allele_id='HLA05970'
        Order By f.allele_id,ue.uexon_name


    Select * From hla_alleles
    Select * from hla_uexon where uexon_iid=2023
    Select * from hla_reads where read_iid=35709
    CACGTTTCTTGGAGTACTCTACGTCTGAGTGTCATTTCTTCAATGGGACGGAGCGGGTGCGGTTCCTGGACAGATACTTCCATAACCAGGAGGAGAACGTGCGCTTCGACAGCGACGTGGGGGAGTTCCGGGCGGTGACGGAGCTGGGGCGGCCTGATGCCGAGTACTGGAACAGCCAGAAGGACATCCTGGAAGACGAGCGGGCCGCGGTGGACACCTACTGCAGACACAACTACGGGGTTGTGGAGAGCTTCACAGTGCAGC AGCGAG
    CACGTTTCTTGGAGTACTCTACGTCTGAGTGTCATTTCTTCAATGGGACGGAGCGGGTGCGGTTCCTGGACAGATACTTCCATAACCAGGAGGAGAACGTGCGCTTCGACAGCGACGTGGGGGAGTTCCGGGCGGTGACGGAGCTGGGGCGGCCTGATGCCGAGTACTGGAACAGCCAGAAGGACATCCTGGAAGACGAGCGGGCCGCGGTGGACACCTACTGCAGACACAACTACGGGGTTGTGGAGAGCTTCACAGTGCAGC GGCGAG

    Select rm.*,a.*
        From hla_join_max rm
            Inner Join hla_uexon ue With (Nolock) On ue.uexon_iid = rm.uexon_iid
            Inner Join hla_features f With (Nolock) On f.feature_nucsequence=ue.uexon_seq
            Inner Join hla_alleles a With (Nolock) On a.allele_id=f.allele_id
        Where 1=1
--            and rm.read_iid=35709
--             And rm.uexon_iid In (2241,2023,1946,12744)
            And a.allele_id In ('HLA00797','HLA14833','HLA17283','HLA17459','HLA05970','HLA06820','HLA10315','HLA12415','HLA14887','HLA16646','HLA17431')
        Order By rm.read_iid, f.feature_name





Select Top 1000 *
    From hla_join

Select Top 1000 *
    From hla_join
*/


