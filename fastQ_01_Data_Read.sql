Set Ansi_nulls On
Go
Set Quoted_identifier On
Go
use [DNA_FASTQ]
Go
-- ==================================================
-- paley 28.08.2017
-- Загрузка данных fastQ
-- ==================================================
-- Пример выполнения
-- exec fastQ_Data_read @file_name='C:\WORK\NGS\DATA\2017_08_23-HLAi-I-II-example\IonXpress_032_21_07_17_115.fastq'
-- ==================================================
-- create Procedure [dbo].[fastQ_Data_Read] as Begin declare @i int; end
-- Grant execute on [fastQ_Data_Read] to public
-- ==================================================
Alter Procedure [dbo].[fastQ_Data_Read]
	@file_name Varchar(Max)=Null
As
Begin
	Set Nocount On;

    -- ==================================================
	-- Declare
	-- ==================================================
	Declare @cData          varchar(max)
           ,@end_Num        Int
	       ,@beg_Num        Int
           ,@start_Num      Int
           ,@read_Str       varchar(max)
	       ,@data_id        varchar(50)
           ,@data_value     varchar(max)
           ,@cSql           nvarchar(max)
           ,@data_quality   varchar(max)

	-- ==================================================
	-- Прочитать из файла
	-- ==================================================
	Print '**************************************************'
	Print 'Чтение данных из файла:'+@file_name
	Print '**************************************************'
	Select @cSql = N'select @cData = cast(t.cData as varchar(max)) from openrowset(bulk '''+@file_name+''', single_clob) t(cData)';
	Exec sp_executesql @cSql
	    ,N'@cData varchar(max) output'
	    ,@cData Output;
	Select @cData

    -- ==================================================
    -- Цикл по данным , запись в файл сырвх данных hls_reads
    -- ==================================================
   	Truncate Table hla_reads

	Select @end_Num = 1
	      ,@beg_Num = 0

	While Isnull(@end_Num ,0)>0
	Begin
	    Select @start_Num   = @end_Num
	    Select @end_Num     = Charindex(Char(10) ,@cData ,@end_Num)
	    If Isnull(@end_Num ,0)>0
	    Begin
	        Select @read_Str = Substring(@cData ,@start_Num ,@end_Num-@start_Num)
	        Print '@start_Num='+Convert(Varchar(15) ,Isnull(@start_Num ,0))+' @end_Num='+Convert(Varchar(15) ,Isnull(@end_Num ,0))+' @read_Str='+@read_Str
	        --if substring(@read_Str,1,7)='@CXZDV:'
	        If Substring(@read_Str ,1 ,1)='@' And @beg_Num In (0 ,4)
	            Select @beg_Num         = 1
	                  ,@data_id         = @read_Str
	                  ,@data_value      = ''
	                  ,@data_quality    = ''
	        Else
	        Select @beg_Num = @beg_Num+1

	        If @beg_Num=2
	        Begin
	            If Substring(@read_Str ,1 ,1) In ('A' ,'C' ,'G' ,'T' ,'N')
	                Select @data_value = @read_Str
	            Else
	            Print 'Ошибка строки 2!'
	        End

	        If @beg_Num=3 And Substring(@read_Str ,1 ,1)<>'+'
	            Print 'Ошибка строки 3!'

	        If @beg_Num=4
	            Insert [hla_reads]
	              (
	                [read_session]
	               ,[read_file]
	               ,[read_datetime]
	               ,[read_sid]
	               ,[read_data]
	               ,[read_quality]
	              )
	            Select @@spid
	                  ,@file_Name
	                  ,Getdate()
	                  ,@data_id
	                  ,@data_value
	                  ,@read_Str

	        Select @end_Num = @end_Num+1
	    End
	End

    -- ==================================================
    -- Цикл по данным, запись в файл хороших данных :) hls_wreads
    -- ==================================================
    Truncate Table hla_wreads
/*
	Insert [hla_wreads] (
	        [read_sid]
	    ,[read_seq]
	    ,[read_seq_e]
        ,[read_qual]
        )
	    Select r.[read_id]
                ,r.[read_data]
                ,r.[read_data]
                ,r.read_quality
            From [hla_reads] r
	        Where len(r.read_data)>110
    Update [hla_wreads]
        Set read_id=Cast(Replace(Replace(read_sid,'@CXZDV',''),':','') As Bigint)
*/

/*
	------ Пример поиска
	If Object_id('tempdb..#result') Is Not Null
	    Drop Table #result

	Select r.read_file
	      ,r.read_id
	      ,f.allele_id
	      ,f.feature_id
	      ,f.feature_name
	      ,f.[SequenceCoordinates_start]
	      ,f.[SequenceCoordinates_end]
	      ,Charindex(Rtrim(f.feature_nucsequence) ,r.read_data) As read_data_charindex
	      ,f.feature_nucsequence
	      ,r.read_data
	       Into #result
	    From hla_reads r With (Nolock)
	        ,hla_features f With (Nolock)
	    Where  f.feature_name In ('Exon 2' ,'Exon 3')
	           --and charindex(substring(f.feature_nucsequence,1,300),r.read_data)>0
	           And Charindex(Rtrim(f.feature_nucsequence) ,r.read_data)>0
	               -- если у брать ссылку на r.read_id, то ищет долго!
	           And r.read_id = '@CXZDV:00326:02286'

	Select *
	    From #result

*/

/*

	-- временная таблица
	If Object_id('tReads') Is Not Null
	    Drop Table tReads

	Create Table tReads
	(
		xCol Varchar(Max)
	)

	-- загрузка файла
	Insert Into tReads
	Select xCol
	    From ( Select *
	               From Openrowset( Bulk 'f:\NGS\HLA\IonXpress_032_21_07_17_115.fastq'
	                     ,Single_clob ) As xCol ) As R(xCol)

	-- размер
	Select Len(xCol)
	    From tReads

	-- обработка
	Declare @cData             Varchar(Max)
	       ,@start_Num         Int
	       ,@end_Num           Int
	       ,@beg_Num           Int
	       ,@read_Str          Varchar(Max)
	       ,@data_id               Varchar(20)
	       ,@data_value       Varchar(Max)
	       ,@data_quality     Varchar(Max)
	       ,@@file_Name        Varchar(100)

	Select @cData = xCol
	      ,@@file_Name = 'IonXpress_032_21_07_17_115.fastq'
	    From tReads

	Truncate Table hla_reads
	--select @end_Num=charindex(char(10),@cData) from tReads

	Select @end_Num = 1
	      ,@beg_Num = 0

	While Isnull(@end_Num ,0)>0
	Begin
	    Select @start_Num = @end_Num
	    Select @end_Num = Charindex(Char(10) ,@cData ,@end_Num)
	    If Isnull(@end_Num ,0)>0
	    Begin
	        Select @read_Str = Substring(@cData ,@start_Num ,@end_Num-@start_Num)
	        Print '@start_Num='+Convert(Varchar(15) ,Isnull(@start_Num ,0))+' @end_Num='+Convert(Varchar(15) ,Isnull(@end_Num ,0))+' @read_Str='+@read_Str
	        --if substring(@read_Str,1,7)='@CXZDV:'
	        If Substring(@read_Str ,1 ,1)='@' And @beg_Num In (0 ,4)
	            Select @beg_Num = 1
	                  ,@data_id               = @read_Str
	                  ,@data_value       = ''
	                  ,@data_quality     = ''
	        Else
	        Select @beg_Num = @beg_Num+1

	        If @beg_Num=2
	        Begin
	            If Substring(@read_Str ,1 ,1) In ('A' ,'C' ,'G' ,'T' ,'N')
	                Select @data_value = @read_Str
	            Else
	            Print 'Ошибка строки 2!'
	        End

	        If @beg_Num=3 And Substring(@read_Str ,1 ,1)<>'+'
	            Print 'Ошибка строки 3!'

	        If @beg_Num=4
	            Insert [hla_reads]
	              (
	                [read_session]
	               ,[read_file]
	               ,[read_datetime]
	               ,[read_id]
	               ,[read_data]
	               ,[read_quality]
	              )
	            Select @@spid
	                  ,@@file_Name
	                  ,Getdate()
	                  ,@data_id
	                  ,@data_value
	                  ,@read_Str

	        Select @end_Num = @end_Num+1
	    End
	End

	------ Пример поиска
	If Object_id('tempdb..#result') Is Not Null
	    Drop Table #result

	Select r.read_file
	      ,r.read_id
	      ,f.allele_id
	      ,f.feature_id
	      ,f.feature_name
	      ,f.[SequenceCoordinates_start]
	      ,f.[SequenceCoordinates_end]
	      ,Charindex(Rtrim(f.feature_nucsequence) ,r.read_data) As read_data_charindex
	      ,f.feature_nucsequence
	      ,r.read_data
	       Into #result
	    From hla_reads r With (Nolock)
	        ,hla_features f With (Nolock)
	    Where  f.feature_name In ('Exon 2' ,'Exon 3')
	           --and charindex(substring(f.feature_nucsequence,1,300),r.read_data)>0
	           And Charindex(Rtrim(f.feature_nucsequence) ,r.read_data)>0
	               -- если у брать ссылку на r.read_id, то ищет долго!
	           And r.read_id = '@CXZDV:00326:02286'

	Select *
	    From #result


















	-- ==================================================
	-- Declare
	-- ==================================================
	Declare @xml        Xml
	       ,@xml_id     Int
	       ,@seq        Varchar(Max)
	       ,@cSql       Nvarchar(Max)

	-- ==================================================
	-- прочитать из файла
	-- ==================================================
	If Isnull(@@file_Name ,'')<>''
	Begin
	    Print '**************************************************'
	    Print 'Чтение данных из файла:'+@@file_Name
	    Print '**************************************************'
	    Declare @x        Xml
	           ,@cData     Nvarchar(128)=N'C:\V009.xml';
	    Select @cSql = 'select @cXml = cast(t.xData as varchar(max)) from openrowset(bulk '''+@@file_Name+''', single_clob) t(xData)';
	    Exec sp_executesql @cSql
	        ,N'@cXml varchar(max) output'
	        ,@cXml Output;
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
	         With ( [allele_id] Varchar(20) '@data_id'
	          ,[allele_name] Varchar(20) '@name'
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
	          ,[sequence_allelename] Varchar(20) 'sequence/alignmentreference/@allelename'
	          ,[sequence_alleleid] Varchar(20) 'sequence/alignmentreference/@alleleid'
	          ,[sequence_nucsequence] Varchar(Max) 'sequence/nucsequence' ) t

	-- ====================================================================================================
	-- Список разбивка по частям
	-- ====================================================================================================
	If Object_id('tempdb..#features') Is Not Null
	    Drop Table #features

	Select *
	       Into #features
	    From Openxml(@xml_id ,'/alleles/allele/sequence/feature' ,2)
	         With ( [allele_id] Varchar(20) '../../@data_id'
	          ,[alignmentreference_allelename] Varchar(20) '../alignmentreference/@allelename'
	          ,[alignmentreference_alleleid] Varchar(20) '../alignmentreference/@alleleid'
	          ,[feature_id] Varchar(20) '@data_id'
	          ,[feature_order] Int '@order'
	          ,[feature_type] Varchar(20) '@featuretype'
	          ,[feature_name] Varchar(20) '@name'
	          ,[feature_status] Varchar(10) '@status'
	          ,[SequenceCoordinates_start] Int 'SequenceCoordinates/@start'
	          ,[SequenceCoordinates_end] Int 'SequenceCoordinates/@end'
	          ,[cDNACoordinates_start] Int 'cDNACoordinates/@start'
	          ,[cDNACoordinates_end] Int 'cDNACoordinates/@end'
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
	Truncate Table hla_alleles
	Insert hla_alleles
	Select a.*
	    From #alleles a

	Truncate Table hla_features
	Insert hla_features
	Select a.*
	    From #features a
*/
End
