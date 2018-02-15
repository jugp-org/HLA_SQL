Set Ansi_nulls On
Go
Set Quoted_identifier On
Go
-- ==================================================
-- Author:		<Yuriy Shirokov>
-- Create date: <26-08-2017>
-- Description:	Load HLA Data From XML
-- ==================================================
-- Пример выполнения
-- exec hla2_XML_read
--    @file_name='C:\WORK\NGS\DATA\hla.xml\hla.xml '
-- ==================================================
-- Create Procedure [dbo].[hla2_XML_read] as Begin declare @i int; end
-- Grant execute on [hla2_XML_read] to public
-- ==================================================
Alter Procedure [dbo].[hla2_XML_read]
    @file_name  Varchar(Max)    = null
   ,@cXml       Varchar(Max)    = null
   -- для записи версии данных
   ,@file_create Datetime       = null
   ,@file_size   Numeric(15)    = null
As
Begin
	Set Nocount On;

	-- ==================================================
	-- Declare
	-- ==================================================
	Declare @xml        Xml
	       ,@xml_id     Int
	       ,@seq        Varchar(Max)
           ,@cSql       nVarchar(Max)
           ,@max_n      Int
           ,@n          Int

    Declare @row_num2   Int
            ,@all_name  varchar(50)
            ,@exon_name varchar(50)
            ,@exon_seq  Varchar(Max)

	-- ==================================================
	-- прочитать из файла
	-- ==================================================
    If isnull(@file_name,'')<>''
    Begin
        print '**************************************************'
        print 'Чтение данных из файла:'+@file_name
        print '**************************************************'
        Select @cSql = 'select @cXml = cast(t.xData as varchar(max)) from openrowset(bulk '''+@file_name+''', single_clob) t(xData)';
        exec sp_executesql @cSql, N'@cXml varchar(max) output', @cXml output;
        
        -- запись версии файла
        Truncate Table hla_version
        Insert hla_version
		(
			[file_name]
		   ,[file_create]
		   ,[file_size]
		   ,[file_loaded]
		)
		Select 
			@file_name
		   ,Isnull(@file_create,'19000101')
		   ,Len(@cXml)
		   ,Getdate()
        					
        -- Select @cXml
    End

	-- ==================================================
	-- Предварительная обработка
	-- ==================================================
	If Charindex('encoding="UTF-8"' ,@cXml)>0
	Begin
	    Select @cXml = Replace(@cXml ,'encoding="UTF-8"' ,'')
	End

	If Charindex('encoding="ISO-8859-1"' ,@cXml)>0
	Begin
	    Select @cXml = Replace(@cXml ,'encoding="ISO-8859-1"' ,'')
	End

	If Charindex( '<alleles xmlns="http://hla.alleles.org/xml" xmlns:xs="http://www.w3.org/2001/XMLSchema" xs:noNamespaceSchemaLocation="http://hla.alleles.org/xml/hla.xsd">'
	    ,@cXml )>0
	Begin
	    Select @cXml = Replace( @cXml
	            ,'<alleles xmlns="http://hla.alleles.org/xml" xmlns:xs="http://www.w3.org/2001/XMLSchema" xs:noNamespaceSchemaLocation="http://hla.alleles.org/xml/hla.xsd">'
	            ,'<alleles>' )
	End

	-- xml_Prepare
	Select @xml = @cXml
	Exec sp_xml_preparedocument @xml_id Output
	    ,@xml

	-- ====================================================================================================
	-- Список alleles
	-- ====================================================================================================
	If Object_id('tempdb..#alleles') Is Not Null
	    Drop Table #alleles

	Select *
	       Into #alleles
	    From Openxml(@xml_id ,'/alleles/allele' ,2)
	         With ( [allele_id] Varchar(30) '@id'
	          ,[allele_name] Varchar(50) '@name'
	          ,[allele_dateassigned] Varchar(10) '@dateassigned'
	          ,[release_firstreleased] Varchar(10) 'releaseversions/@firstreleased'
	          ,[release_lastupdated] Varchar(10) 'releaseversions/@lastupdated'
	          ,[release_currentrelease] Varchar(10) 'releaseversions/@currentrelease'
	          ,[release_status] Varchar(20) 'releaseversions/@releasestatus'
	          ,[release_confirmed] Varchar(20) 'releaseversions/@confirmed'
	          ,[hla_g_group] Varchar(30) 'hla_g_group/@status'
	          ,[hla_p_group] Varchar(30) 'hla_p_group/@status'
	          ,[locus_genesystem] Varchar(10) 'locus/@genesystem'
	          ,[locus_name] Varchar(20) 'locus/@locusname'
	          ,[locus_hugogenename] Varchar(20) 'locus/@hugogenename'
	          ,[locus_class] Varchar(10) 'locus/@class'
	          ,[cwd_status] Varchar(30) 'cwd_catalogue/@cwd_status'
	          ,[cwd_version] Varchar(30) 'cwd_catalogue/@cwd_version'
	          ,[cwd_reference] Varchar(80) 'cwd_catalogue/@cwd_reference'
	          ,[sequence_allelename] Varchar(30) 'sequence/alignmentreference/@allelename'
	          ,[sequence_alleleid] Varchar(30) 'sequence/alignmentreference/@alleleid'
	          ,[sequence_nucsequence] Varchar(Max) 'sequence/nucsequence' ) t

	-- ====================================================================================================
	-- Список разбивка по частям
	-- ====================================================================================================
	If Object_id('tempdb..#features') Is Not Null
	    Drop Table #features

	Select *
	       Into #features
	    From Openxml(@xml_id ,'/alleles/allele/sequence/feature' ,2)
	         With (
               [allele_id] Varchar(30) '../../@id'
	          ,[alignmentreference_allelename] Varchar(30) '../alignmentreference/@allelename'
	          ,[alignmentreference_alleleid] Varchar(30) '../alignmentreference/@alleleid'
	          ,[feature_id] Varchar(30) '@id'
	          ,[feature_order] Int '@order'
	          ,[feature_type] Varchar(20) '@featuretype'
	          ,[feature_name] Varchar(30) '@name'
	          ,[feature_status] Varchar(10) '@status'
	          ,[SequenceCoordinates_start] Int 'SequenceCoordinates/@start'
	          ,[SequenceCoordinates_end] Int 'SequenceCoordinates/@end'
	          ,[cDNACoordinates_start] Int 'cDNACoordinates/@start'
	          ,[cDNACoordinates_end] Int 'cDNACoordinates/@end'
	          ,[cDNAindel_start] Int 'cDNAindel/@start'
	          ,[cDNAindel_end] Int 'cDNAindel/@end'
	          ,[cDNAindel_size] Int 'cDNAindel/@size'
	          ,[cDNAindel_type] varchar(20) 'cDNAindel/@type'
	          ,[feature_nucsequence] Varchar(Max) 'nucsequence' ) t

	-- Разбивка на части
	Update #features
		Set    feature_nucsequence = Substring( a.sequence_nucsequence
		        ,f.SequenceCoordinates_start
		        ,f.SequenceCoordinates_end-f.SequenceCoordinates_start+1 )
		From   #features f
	          ,#alleles a
		Where  f.allele_id = a.allele_id
		       And Isnull(f.SequenceCoordinates_start ,0)<>0

	--Select len(rtrim(sequence_nucsequence)),* From #alleles
	--Select len(rtrim(feature_nucsequence)),* from #features

	-- Обновить данные
    Print 'Insert hla_alleles'
	Truncate Table hla_alleles
	Insert hla_alleles
	Select a.*
	    From #alleles a

    Print 'Insert hla_features'
	Truncate Table hla_features
	Insert hla_features
        (   [allele_id],
            [alignmentreference_alleleid],
            [alignmentreference_allelename],
            [feature_id],
            [feature_order],
            [feature_type],
            [feature_name],
            [feature_status],
            [SequenceCoordinates_start],
            [SequenceCoordinates_end],
            [cDNACoordinates_start],
            [cDNACoordinates_end],
            [cDNAindel_start],
            [cDNAindel_end],
            [cDNAindel_size],
            [cDNAindel_type],
            [feature_nucsequence])
	Select a.*
	    From #features a


	-- ==================================================
	-- init
	-- ==================================================
	Update hla_features
        Set feature_len=Len([feature_nucsequence])

-- Вынесено в процедуру hla2_XML_PostLoad_proc !!!!!!!

/*
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
        ,gen_cd)
        Select Case 
                    when f.feature_name='Exon 2' then 2
                    when f.feature_name='Exon 3' then 3
                    when f.feature_name='Exon 4' then 4
                End
			,f.feature_nucsequence
            ,Replace(Substring(a.allele_name,1,Charindex('*',a.allele_name)-1),'HLA-','')
			From hla_features f
			Inner Join hla_alleles a On a.allele_id=f.allele_id          
			where 1=1
				and f.feature_type ='Exon'
				and f.feature_name in ('Exon 2','Exon 3','Exon 4')
				and f.[feature_status]='Complete'
				-- And a.release_confimed='Confirmed'
			Group by f.feature_name
                    ,f.feature_nucsequence
                    ,Replace(Substring(a.allele_name,1,Charindex('*',a.allele_name)-1),'HLA-','')

    -- Это все первые половинки
    Update hla_uexon
        Set uexon_half_iid	= uexon_iid
        	,k_forward_back	= 1

    Print '=================================================='
    Print '*** Добавить комплиментарные половинки'
    Insert Into hla_uexon
        (uexon_num, gen_cd, uexon_seq, k_forward_back, uexon_half_iid)
        Select
			u.uexon_num
            ,u.gen_cd
            ,u.uexon_seq
            ,2
            ,u.uexon_half_iid
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
*/        

End
