-- ==================================================
-- yu.shirokov 20.11.2017
-- Выполнение процедур после загрузки некласических генов
-- ==================================================
-- Пример выполнения
-- ==================================================
/*
	create Procedure [dbo].[hla3_Exon_Init] as Begin declare @i int; end
	Grant execute on [hla3_Exon_Init] to public
*/
-- ==================================================
Alter Procedure [dbo].[hla3_Exon_Init]
As
Begin

    Declare @row_num2   Int
            ,@all_name  varchar(50)
            ,@exon_name varchar(50)
            ,@exon_seq  Varchar(Max)

	-- ==================================================
	-- Уникальные экзоны
	-- ==================================================
    Print '=================================================='
    Print '*** Инициализация hla3_uexon'
    Truncate Table hla3_uexon

    Insert Into hla3_uexon
        (uexon_num
        ,uexon_seq
        ,gen_cd
        ,uexon_uid)
        Select 
                Case 
                    when f.feature_name='Exon 2' then 2
                    when f.feature_name='Exon 3' then 3
                    when f.feature_name='Exon 4' then 4
                End
			    ,f.feature_nucsequence
                ,Replace(Substring(a.allele_name,1,Charindex('*',a.allele_name)-1),'HLA-','')
                -- Установить ид. уникальных последовательностей uexon_uid
                ,Rank() Over (Order by f.feature_name,f.feature_nucsequence) as uexon_uid      
			From hla3_features f
			Inner Join hla3_alleles a On a.allele_id=f.allele_id          
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
    Update hla3_uexon
        Set uexon_half_iid	= uexon_iid
        	,k_forward_back	= 1


    Print '=================================================='
    Print '*** Добавить комплиментарные половинки'
    Insert Into hla3_uexon
        (uexon_num, gen_cd, uexon_seq, k_forward_back, uexon_half_iid,uexon_uid)
        Select
			u.uexon_num
            ,u.gen_cd
            ,u.uexon_seq
            ,2
            ,u.uexon_half_iid
            ,u.uexon_uid
        From hla3_uexon u
        Where k_forward_back = 1

	-- Перевернули
    Update hla3_uexon
        Set uexon_seq	= REVERSE(uexon_seq)
        Where k_forward_back = 2

	-- Заменили на комплиментарную
    -- A->1->T
    -- T->2->A
    -- C->3->G
    -- G->4->C
    Update hla3_uexon
        Set uexon_seq	= Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(uexon_seq,'A','1'),'T','2'),'C','3'),'G','4'),'1','T'),'2','A'),'3','G'),'4','C')
        Where k_forward_back = 2

    -- ==================================================
    -- Длина 
    -- ==================================================
    Update hla3_uexon
        Set uexon_len = Len(uexon_seq)


End
