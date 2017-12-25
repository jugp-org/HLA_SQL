-- ==================================================
-- paley 27.09.2017
-- ==================================================
-- Выравнивание экзонов в аллелях
-- ==================================================
-- Create Procedure [dbo].[hla3_Exon_Align] as Begin declare @i int; end
-- Grant execute on [hla3_Exon_Align] to public
-- ==================================================
Alter Procedure [dbo].[hla3_Exon_Align]
As
Begin

    Print '=================================================='
    Print '*** [hla3_Exon_Align]'


    -- ****************************************************************************************************
    -- *** Выравнивание экзонов в аллелях
    -- ****************************************************************************************************
    -- ==================================================
    -- Цикл выравнивания
    -- ==================================================
    Declare  @fexon_iid     Int
            ,@all_name      varchar(50)
            ,@gen_cd        varchar(50)
            ,@exon_name     varchar(50)
            ,@exon_seq      Varchar(Max)
            ,@exon_len      Int
            ,@exon_Num      Int

    Print '=================================================='
    Print '*** Выравнивание экзонов в аллелях'
    Truncate Table [hla3_fexon_align]

    -- Список первых аллелей для каждого экзона, на которые будем потом выравнивать 
    Insert [hla3_fexon_align] (
	    [allele_iid]
	   ,[allele_name]
       ,[gen_cd]
	   ,[exon_num]
	   ,[exon_seq]
       ,[uexon_iid]
    )
    Select t.allele_iid
            ,t.allele_name
            ,t.gen_cd
	        ,t.exon_num
	        ,t.exon_seq
            ,ue.uexon_iid
        From (
            -- Список аллелей для каждого экзона, пронумерованных по порядку
            Select a.allele_name
                    ,allele_iid     = a.allele_iid
                    ,gen_cd         = Replace(Substring(a.allele_name,1,Charindex('*',a.allele_name)-1),'HLA-','')
                    ,exon_num       = Cast(Replace(f.feature_name,'Exon','') As Numeric(2))
                    ,exon_seq       = f.feature_nucsequence
                    ,exon_len       = f.feature_len
                    ,row_num        = Row_number() Over(Partition By f.feature_name,Substring(a.allele_name,1,Charindex('*',a.allele_name)) Order By f.feature_name,a.allele_name) 
                From dna2_hla.dbo.hla3_features f With (Nolock) 
                    Inner Join dna2_hla.dbo.hla3_alleles a With (Nolock) On a.allele_iid=f.allele_iid
                Where 1=1
                    And f.[feature_status]='Complete'
                    And f.feature_type='Exon'
                    And f.feature_name In ('Exon 2','Exon 3','Exon 4')
                    And Isnull(f.feature_nucsequence,'')<>''
                ) As t
        Inner Join dna2_hla.dbo.hla3_uexon ue With (Nolock) On ue.uexon_seq=t.exon_seq
        Where t.row_num=1
        Order By t.gen_cd,t.allele_name,t.exon_num
-- Select * From [hla3_fexon_align] order by gen_cd,exon_num

    -- ==================================================
    -- Цикл по родительским экзонам
    -- ==================================================
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
        Update dna2_hla.dbo.hla3_uexon
            Set 
                uexon_diff_seq=dbo.sql_str_rank_sdiff(ue.uexon_seq,@exon_seq)
            From dna2_hla.dbo.hla3_uexon ue With (Nolock) 
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

End