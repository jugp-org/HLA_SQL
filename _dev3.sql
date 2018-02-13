 -- ****************************************************************************************************
 -- Сервис
 -- ****************************************************************************************************

-- ****************************************************************************************************
-- Hla3
-- ****************************************************************************************************
    -- ==================================================
	-- Список аллелей 
    -- ==================================================
	Select a.allele_name
		,Substring(a.allele_name,1,Charindex('*',a.allele_name))
		,a.hla_g_group
        ,a.allele_id
	From hla3_alleles a With (Nolock) 
	Where 1=1
        And a.hla_g_group In ('A*02:01:01G')
	Order By a.allele_name  


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
 		and f.feature_name In ('Exon 2')
 		--and (
 		--	(f.feature_name In ('Exon 2', 'Exon 3') And Len(Substring(a.allele_name,1,Charindex('*',a.allele_name)))=6)
 		--	or
 		--	(f.feature_name In ('Exon 2') And Len(Substring(a.allele_name,1,Charindex('*',a.allele_name)))=9)
 		--)
 		--And a.allele_name In ('HLA-C*06:116N') 
        And a.hla_g_group In ('A*02:01:01G')
 		--And f.feature_nucsequence='GTTCTCACACCCTCCAGTGGATGATTGGCTGCGACCTGGGGTCCGACGGACGCCTCCTCCGCGGGTATGAACAGTATGCCTACGATGGCAAGGATTACCTCGCCCTGAACGAGGACCTGCGCTCCTGGACCGCAGCGGACACTGCGGCTCAGATCTCCAAGCGCAAGTGTGAGGCGGCCAATGTGGCTGAACAAAGGAGAGCCTACCTGGAGGGCACGTGCGTGGAGTGGCTCCACAGATACCTGGAGAACGGGAAGGAGATGCTGCAGCGCGCGG'
 		--And f.feature_nucsequence='GTTCTCACACCCTCCAGTGGATGATTGGCTGCGACCTGGGGTCCGACGGACGCCTCCTCCGCGGGTATGAACAGTATGCCTACGATGGCAAGGATTACCTCGCCCTGAACGAGGACCTGCGCTCCTGGACCGCAGCGGACACTGCGGCTCAGATCTCCAAGCGCAAGTGTGAGGCGGCCAATGTGGCTGAACAAAGGAGAGCCTACCTGGAGGGCACGTGCGTGGAGTGGCTCCACAGATACCTGGAGAACGGGAAGGAGATGCTGCAGCGCGCG*'
 		--And f.feature_nucsequence Like '%CACGTTTCCTGTGGCAGCCTAAGAGGGAGTGTCATTTCTTCAATGGGACGGAGCGGGTGCGGTTCCTGGACAGATACTTCTATAATCAGGAGGAGTCCGTGCGCTTCGACAGCGACGTGGGGGAGTTCCGGGCGGTGACGGAGCTGGGGCGGCCTGACGCTGAGTACTGGAACAGCCAGAAGGACATCCTGGAGCAGGCGCGGGCCGCGGTGGACACCTACTGCAGACACAACTACGGGGTTGGTG________________________%'
	Order By f.feature_name, a.allele_name  


    -- ==================================================
	-- Список уникальных экзонов 
    -- ==================================================
	Select 
        ue.*
	    From hla3_uexon ue With (Nolock) 
	Where 1=1
        and ue.k_forward_back=1
 		and ue.uexon_num=2
        And ue.gen_cd='B'

    -- ==================================================
	-- Список экзонов для выравнивания
    -- ==================================================
	Select Len(fa.exon_seq),fa.*
        From hla3_fexon_align fa
        Order By fa.gen_cd,fa.exon_num


    -- ==================================================
	-- Список длин уникальных  экзонов 
    -- ==================================================
	Select 
            ue.gen_cd
            ,ue.uexon_num
            ,Len(ue.uexon_seq)
            ,Count(*)
	    From hla3_uexon ue With (Nolock) 
	Where 1=1
        and ue.k_forward_back=1
    Group By ue.gen_cd
            ,ue.uexon_num
            ,Len(ue.uexon_seq)
    Order By ue.gen_cd
            ,ue.uexon_num
            ,Len(ue.uexon_seq)

    -- Группировка по первым символам
	Select 
            ue.gen_cd
            ,ue.uexon_num
            ,Count(*)
	    From hla3_uexon ue With (Nolock) 
	Where 1=1
        and ue.k_forward_back=1
    Group By ue.gen_cd
            ,ue.uexon_num
            ,Substring(ue.uexon_seq,1,276)
            having count(*)>1
    Order By ue.gen_cd
            ,ue.uexon_num


    -- ====================================================================================================
    -- ====================================================================================================
    -- Тест выравнивания
    -- ====================================================================================================
    -- ====================================================================================================

    -- ==================================================
    -- Тест выравнивания
    -- Тест расчета расстояния
    -- ==================================================
    Select *
        From hla3_fexon_align

    Select @exon_seq=exon_seq
        From hla3_fexon_align
        Where gen_cd='B'
        And exon_num=1
    -- 'GCTCCCACTCCATGAGGTATTTCTACACCTCCGTGTCCCGGCCCGGCCGCGGGGAGCCCCGCTTCATCTCAGTGGGCTACGTGGACGACACCCAGTTCGTGAGGTTCGACAGCGACGCCGCGAGTCCGAGAGAGGAGCCGCGGGCGCCGTGGATAGAGCAGGAGGGGCCGGAGTATTGGGACCGGAACACACAGATCTACAAGGCCCAGGCACAGACTGACCGAGAGAGCCTGCGGAACCTGCGCGGCTACTACAACCAGAGCGAGGCCG'
    Select dist_val = dbo.sql_str_distance(ue.uexon_seq,@exon_seq)
            ,dbo.sql_str_rank_sdiff(ue.uexon_seq,@exon_seq)
            From dna2_hla.dbo.hla3_uexon ue With (Nolock) 
            Where 1=1
                And ue.k_forward_back   = 1
                And ue.gen_cd           = 'B'
                And ue.uexon_num        = 2
        Order By dist_val

    -- ==================================================
    -- Тест выравнивания
    -- ==================================================
    Declare  @fexon_iid     Int
            ,@all_name      varchar(50)
            ,@gen_cd        varchar(50)
            ,@exon_name     varchar(50)
            ,@exon_seq      Varchar(Max)
            ,@exon_len      Int
            ,@exon_Num      Int

    If Object_id('tempdb..#_lst_uexon') is Not null
        Drop table #_lst_uexon
    Select ue.*
        ,dist_val   = cast(0 As Numeric(10))
        Into #_lst_uexon
        From hla3_uexon ue

    -- Цикл по родительским экзонам
    Select @fexon_iid=Min(fexon_iid)
        From [hla3_fexon_align]

    While Isnull(@fexon_iid,0)<>0
    Begin
        Select @all_name    = t.allele_name
              ,@exon_num    = t.exon_num
              ,@exon_seq    = t.exon_seq
              ,@gen_cd      = t.gen_cd
              ,@exon_len    = t.exon_len
            From [hla3_fexon_align] t
            Where fexon_iid=@fexon_iid
            
        Print '*** Обработка:'+@all_name+' exon='+cast(@exon_num As Varchar(3))+' len='+cast(@exon_len As Varchar(5))+' seq='+@exon_seq

        -- Список аллелей для каждого экзона, пронумерованных по порядку
        Update #_lst_uexon
            Set 
                dist_val = dbo.sql_str_distance(ue.uexon_seq,@exon_seq)
            From #_lst_uexon ue With (Nolock) 
            Where 1=1
                And ue.k_forward_back   = 1
                And ue.gen_cd           = @gen_cd
                And ue.uexon_num        = @exon_num

    	-- Продолжить цикл
        Select @fexon_iid=Min(fexon_iid)
            From [hla3_fexon_align]
            Where fexon_iid>@fexon_iid
        -- Break
    End

    Select gen_cd, uexon_num, dist_val, Count(*)
        From  #_lst_uexon ue
        Where 1=1
            And ue.k_forward_back   = 1
        Group By gen_cd, uexon_num, dist_val
        Order By gen_cd, uexon_num, dist_val

    Select *
        From  #_lst_uexon
        Where gen_cd='A'
            And uexon_num=2
            And dist_val=0

        Group By gen_cd, uexon_num, dist_val
        Order By gen_cd, uexon_num, dist_val



    -- ====================================================================================================
	-- Список экзонов с [*]
    -- ====================================================================================================
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

    -- ====================================================================================================
	-- Совпадение экзонов с [*] с любыми другими по маске
    -- ====================================================================================================
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



    -- ====================================================================================================
    -- ====================================================================================================
    -- Список похожих последовательностей
    -- Одна длиннее - другая короче и... совпадают :)
    -- ====================================================================================================
    -- ====================================================================================================
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


    -- ====================================================================================================
    -- Список вариантов
    -- ====================================================================================================
    If Object_id('tempdb..#_allele') is Not null
        Drop table #_allele
    If Object_id('tempdb..#_allele1') is Not null
        Drop table #_allele1
    If Object_id('tempdb..#_allele4_1') is Not null
        Drop table #_allele4_1
    If Object_id('tempdb..#_allele4_2') is Not null
        Drop table #_allele4_2

    ;With _cte2 As (
        Select a.*
                ,exon2_uid  = ue.uexon_uid
            From hla3_alleles a
                Inner Join hla3_features f With (Nolock) On f.allele_iid=a.allele_iid And f.feature_name='Exon 2'
                Inner Join hla3_uexon ue With (Nolock) On ue.uexon_seq=f.feature_nucsequence And Charindex(ue.gen_cd+'*',a.allele_name)>0
            Where Substring(a.allele_name,1,5) In ('HLA-A','HLA-B','HLA-C')
    ), _cte3 as (
        Select a.*
                ,exon3_uid  = ue.uexon_uid
            From hla3_alleles a
                Inner Join hla3_features f With (Nolock) On f.allele_iid=a.allele_iid And f.feature_name='Exon 3'
                Inner Join hla3_uexon ue With (Nolock) On ue.uexon_seq=f.feature_nucsequence And Charindex(ue.gen_cd+'*',a.allele_name)>0
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

    --Select *
    --    From #_allele
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
    Select  row_id      = Row_number() Over(Order By a1.allele_name,a2.allele_name,a3.allele_name,a4.allele_name)
            ,a1_name    = a1.allele_name
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
    --Select t1.*
    --    From #_allele1 t1

    -- Список уникальных
    Select  row_id
            ,a1_name    
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

    -- ==================================================
    -- Обработка 4 экзона
    -- ==================================================
    -- Экзоны с данными
    Select distinct row_id
            ,a_type = 1
            ,a_ex4  = ue.uexon_uid
        Into #_allele4_1
        From #_allele1 t
            Inner Join hla3_alleles a On t.a1_name=Case when charindex('G',t.a1_name)>0 Then a.hla_g_group Else Replace(a.allele_name,'HLA-','') end
            Inner Join hla3_features f With (Nolock) On f.allele_iid=a.allele_iid And f.feature_name='Exon 4'
            Inner Join hla3_uexon ue With (Nolock) On ue.uexon_seq=f.feature_nucsequence And Charindex(ue.gen_cd+'*',t.a1_name)>0
        Where t.a1_name < t.a3_name

    Insert #_allele4_1
        Select distinct row_id
                ,a_type = 3
                ,a_ex4  = ue.uexon_uid
            From #_allele1 t
                Inner Join hla3_alleles a On t.a3_name=Case when charindex('G',t.a3_name)>0 Then a.hla_g_group Else Replace(a.allele_name,'HLA-','') end
                Inner Join hla3_features f With (Nolock) On f.allele_iid=a.allele_iid And f.feature_name='Exon 4'
                Inner Join hla3_uexon ue With (Nolock) On ue.uexon_seq=f.feature_nucsequence And Charindex(ue.gen_cd+'*',t.a3_name)>0
            Where t.a1_name < t.a3_name

    Insert #_allele4_1
        Select distinct row_id
                ,a_type = 2
                ,a_ex4  = ue.uexon_uid
            From #_allele1 t
                Inner Join hla3_alleles a On t.a2_name=Case when charindex('G',t.a2_name)>0 Then a.hla_g_group Else Replace(a.allele_name,'HLA-','') end
                Inner Join hla3_features f With (Nolock) On f.allele_iid=a.allele_iid And f.feature_name='Exon 4'
                Inner Join hla3_uexon ue With (Nolock) On ue.uexon_seq=f.feature_nucsequence And Charindex(ue.gen_cd+'*',t.a2_name)>0
            Where t.a1_name < t.a3_name

    Insert #_allele4_1
        Select distinct row_id
                ,a_type = 4
                ,a_ex4  = ue.uexon_uid
            From #_allele1 t
                Inner Join hla3_alleles a On t.a4_name=Case when charindex('G',t.a4_name)>0 Then a.hla_g_group Else Replace(a.allele_name,'HLA-','') end
                Inner Join hla3_features f With (Nolock) On f.allele_iid=a.allele_iid And f.feature_name='Exon 4'
                Inner Join hla3_uexon ue With (Nolock) On ue.uexon_seq=f.feature_nucsequence And Charindex(ue.gen_cd+'*',t.a4_name)>0
            Where t.a1_name < t.a3_name

    -- Звездочки
    Insert #_allele4_1
    Select distinct row_id
            ,a_type = 1
            ,a_ex4  = -1
        From #_allele1 t
            Inner Join hla3_alleles a On t.a1_name=Case when charindex('G',t.a1_name)>0 Then a.hla_g_group Else Replace(a.allele_name,'HLA-','') end
            Inner Join hla3_features f With (Nolock) On f.allele_iid=a.allele_iid And f.feature_name='Exon 4'
        Where t.a1_name < t.a3_name
            And Replace(f.feature_nucsequence,'*','')=''

    Insert #_allele4_1
        Select distinct row_id
                ,a_type = 3
                ,a_ex4  = -1
            From #_allele1 t
                Inner Join hla3_alleles a On t.a3_name=Case when charindex('G',t.a3_name)>0 Then a.hla_g_group Else Replace(a.allele_name,'HLA-','') end
                Inner Join hla3_features f With (Nolock) On f.allele_iid=a.allele_iid And f.feature_name='Exon 4'
            Where t.a1_name < t.a3_name
                And Replace(f.feature_nucsequence,'*','')=''

    Insert #_allele4_1
        Select distinct row_id
                ,a_type = 2
                ,a_ex4  = -1
            From #_allele1 t
                Inner Join hla3_alleles a On t.a2_name=Case when charindex('G',t.a2_name)>0 Then a.hla_g_group Else Replace(a.allele_name,'HLA-','') end
                Inner Join hla3_features f With (Nolock) On f.allele_iid=a.allele_iid And f.feature_name='Exon 4'
            Where t.a1_name < t.a3_name
                And Replace(f.feature_nucsequence,'*','')=''

    Insert #_allele4_1
        Select distinct row_id
                ,a_type = 4
                ,a_ex4  = -1
            From #_allele1 t
                Inner Join hla3_alleles a On t.a4_name=Case when charindex('G',t.a4_name)>0 Then a.hla_g_group Else Replace(a.allele_name,'HLA-','') end
                Inner Join hla3_features f With (Nolock) On f.allele_iid=a.allele_iid And f.feature_name='Exon 4'
            Where t.a1_name < t.a3_name
                And Replace(f.feature_nucsequence,'*','')=''
    -- Индекс
    Create Index tmp_allele4_1_idx1 On #_allele4_1(row_id,a_ex4,a_type)

    -- Выборки
    Select t1.*
            ,t2.*
            ,t3.*
            ,t4.*
        From #_allele4_1 t1
            inner Join #_allele4_1 t2 On t2.row_id=t1.row_id And t2.a_type=2 And (t2.a_ex4=t1.a_ex4 Or t2.a_ex4=-1)
            inner Join #_allele4_1 t3 On t3.row_id=t1.row_id And t3.a_type=3 And (t3.a_ex4=t1.a_ex4 Or t3.a_ex4=-1)
            inner Join #_allele4_1 t4 On t4.row_id=t1.row_id And t4.a_type=4 And (t4.a_ex4=t1.a_ex4 Or t4.a_ex4=-1)
        Where t1.a_type=1
        Order By t1.row_id

    Select t1.*
        From #_allele4_1 t1
        Where 1=1
           And t1.row_id=1
        Order By t1.row_id

    Select *
        From #_allele1 t1      
        Where 1=1
           And t1.row_id=1

    Select a.*
        From #_allele1 t
            Inner Join hla3_alleles a On t.a2_name=Case when charindex('G',t.a2_name)>0 Then a.hla_g_group Else Replace(a.allele_name,'HLA-','') end
            Inner Join hla3_features f With (Nolock) On f.allele_iid=a.allele_iid And f.feature_name='Exon 4'
            Inner Join hla3_uexon ue With (Nolock) On ue.uexon_seq=f.feature_nucsequence And Charindex(ue.gen_cd+'*',t.a2_name)>0
        Where t.row_id=1


    Select a.*
            ,f.*
        From hla3_alleles a 
            Inner Join hla3_features f With (Nolock) On f.allele_iid=a.allele_iid And f.feature_name='Exon 4'
            --Inner Join hla3_uexon ue With (Nolock) On ue.uexon_seq=f.feature_nucsequence
        Where Replace(f.feature_nucsequence,'*','')=''


