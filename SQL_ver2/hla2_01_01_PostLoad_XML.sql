-- ==================================================
-- yu.shirokov 20.11.2017
-- Выполнение процедур после загрузки некласических генов
-- ==================================================
-- Пример выполнения
-- ==================================================
/*
	create Procedure [dbo].[hla2_XML_PostLoad_proc] as Begin declare @i int; end
	Grant execute on [hla2_XML_PostLoad_proc] to public
*/
-- ==================================================
Alter Procedure [dbo].[hla2_XML_PostLoad_proc]
As
Begin

    Declare @row_num2   Int
            ,@all_name  varchar(50)
            ,@exon_name varchar(50)
            ,@exon_seq  Varchar(Max)

	-- ==================================================
	-- init feature_len
	-- ==================================================
	Update hla_features
        Set feature_len=Len([feature_nucsequence])


	-- ==================================================
    -- Diff
	-- ==================================================
    Print '=================================================='
    Print '*** Выравнивание экзонов в аллелях'
    If Object_id('tempdb..#exon_lst') Is Not Null
        drop Table #exon_lst
    -- Список первых аллелей , на которые будем потом выравнивать 
    Select t.*
           ,row_num2 = Row_number() Over(order By t.allele_name,t.exon_name)
        Into #exon_lst
        From (
            -- Список аллелей для каждого экзона , пронумерованных по порядку
            Select a.allele_name
                    ,allele_id      = a.allele_id
                    ,allele_name_s  = Substring(a.allele_name,1,Charindex('*',a.allele_name))
                    ,exon_name      = f.feature_name
                    ,exon_seq       = f.feature_nucsequence
                    ,row_num        = Row_number() Over(Partition By f.feature_name,Substring(a.allele_name,1,Charindex('*',a.allele_name)) Order By f.feature_name,a.allele_name) 
                From DNA2_HLA.dbo.hla_features f With (Nolock) 
                    Inner Join DNA2_HLA.dbo.hla_alleles a With (Nolock) On a.allele_id=f.allele_id
                Where 1=1
                    And f.[feature_status]='Complete'
                    And f.feature_type='Exon'
                    And f.feature_name In ('Exon 2','Exon 3','Exon 4') 
                    --And (
                    --    (f.feature_name In ('Exon 2','Exon 3','Exon 4') And (a.allele_name Like 'HLA-A*%' Or a.allele_name Like 'HLA-B*%' Or a.allele_name Like 'HLA-C*%'))
                    --    Or 
                    --    (f.feature_name ='Exon 2' And (a.allele_name Like 'HLA-DPB1*%' Or a.allele_name Like 'HLA-DRB1*%' Or a.allele_name Like 'HLA-DQB1*%'))
                    --)
                    And Isnull(f.feature_nucsequence,'')<>''
                ) As t
        Inner Join DNA2_HLA.dbo.hla_uexon ue With (Nolock) On ue.uexon_seq=t.exon_seq
        Where t.row_num=1
    Order By t.allele_name,t.exon_name

/*
    Select * From #exon_lst

    Declare @row_num2   Int
            ,@all_name  varchar(50)
            ,@exon_name varchar(50)
            ,@exon_seq  Varchar(Max)
*/
    -- Цикл по родительским экзонам
    Select @row_num2=Min(row_num2)
        From #exon_lst
    While Isnull(@row_num2,0)<>0
    Begin
        Select @all_name    = t.allele_name_s
              ,@exon_name   = t.exon_name
              ,@exon_seq    = t.exon_seq
            From #exon_lst t
            Where row_num2=@row_num2
            
        Print '*** Обработка:'+@all_name+' '+@exon_name
        -- Список аллелей для каждого экзона , пронумерованных по порядку
        Update DNA2_HLA.dbo.hla_features
            Set feature_diff_first=dbo.sql_str_distance_sdiff_from_point(f.feature_nucsequence,@exon_seq,1,1)
            From DNA2_HLA.dbo.hla_features f With (Nolock) 
                Inner Join DNA2_HLA.dbo.hla_alleles a With (Nolock) On a.allele_id=f.allele_id
            Where 1=1
                And Substring(a.allele_name,1,Len(@all_name)) = @all_name
                And f.[feature_status]='Complete'
                And f.feature_type='Exon'
                And f.feature_name = @exon_name
                And Isnull(f.feature_nucsequence,'')<>''

    	-- Продолжить цикл
        Select @row_num2=Min(row_num2)
            From #exon_lst
            Where row_num2>@row_num2
        -- Break
    End


	-- ==================================================
	-- Уникальные экзоны
	-- ==================================================
    Print '=================================================='
    Print '*** Инициализация hla_uexon'
    Truncate Table hla_uexon

    Insert Into hla_uexon
        (uexon_num
        ,uexon_seq
        ,gen_cd
        ,uexon_uid)
        Select Case 
                    when f.feature_name='Exon 2' then 2
                    when f.feature_name='Exon 3' then 3
                    when f.feature_name='Exon 4' then 4
                End
			,f.feature_nucsequence
            ,Replace(Substring(a.allele_name,1,Charindex('*',a.allele_name)-1),'HLA-','')
            -- Установить ид. уникальных последовательностей uexon_uid
            ,Rank() Over (Order by f.feature_name,f.feature_nucsequence) as uexon_uid      
			From hla_features f
			Inner Join hla_alleles a On a.allele_id=f.allele_id          
			where 1=1
				and f.feature_type ='Exon'
				and f.feature_name in ('Exon 2','Exon 3','Exon 4')
				and f.[feature_status]='Complete'
				And Isnull(f.feature_nucsequence,'')<>''
				-- And a.release_confimed='Confirmed'
			Group by f.feature_name
                    ,f.feature_nucsequence
                    ,Replace(Substring(a.allele_name,1,Charindex('*',a.allele_name)-1),'HLA-','')
            Order By f.feature_name
                    ,f.feature_nucsequence
                    ,Replace(Substring(a.allele_name,1,Charindex('*',a.allele_name)-1),'HLA-','')

    -- Это все первые половинки
    Update hla_uexon
        Set uexon_half_iid	= uexon_iid
        	,k_forward_back	= 1

    


    Print '=================================================='
    Print '*** Добавить комплиментарные половинки'
    Insert Into hla_uexon
        (uexon_num, gen_cd, uexon_seq, k_forward_back, uexon_half_iid,uexon_uid)
        Select
			u.uexon_num
            ,u.gen_cd
            ,u.uexon_seq
            ,2
            ,u.uexon_half_iid
            ,u.uexon_uid
        From hla_uexon u

	-- Перевернули
    Update hla_uexon
        Set uexon_seq	= REVERSE(uexon_seq)
        Where k_forward_back = 2

	-- Заменили на комплиментарную
    -- A->1->T
    -- T->2->A
    -- C->3->G
    -- G->4->C
    Update hla_uexon
        Set uexon_seq	= Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(uexon_seq,'A','1'),'T','2'),'C','3'),'G','4'),'1','T'),'2','A'),'3','G'),'4','C')
        Where k_forward_back = 2


    -- ==================================================
    -- Длина 
    -- ==================================================
    Update hla_uexon
        Set uexon_len = Len(uexon_seq)


End
