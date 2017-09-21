Set Ansi_nulls On
Go
Set Quoted_identifier On
Go
-- ==================================================
-- Author:		<Yuriy Shirokov>
-- Create date: <26-08-2017>
-- Description:	Load HLA Data From XML
-- ==================================================
-- ������ ����������
-- exec hla_XML_read
--    @file_name='C:\WORK\NGS\DATA\hla.xml\hla.xml '
-- ==================================================
-- create Procedure [dbo].[hla_XML_read] as Begin declare @i int; end
-- Grant execute on [hla_XML_read] to public
-- ==================================================
Alter Procedure [dbo].[hla_XML_read]
    @file_name  Varchar(Max)    = null
   ,@cXml       Varchar(Max)    = null
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

	-- ==================================================
	-- ��������� �� �����
	-- ==================================================
    If isnull(@file_name,'')<>''
    Begin
        print '**************************************************'
        print '������ ������ �� �����:'+@file_name
        print '**************************************************'
        Select @cSql = 'select @cXml = cast(t.xData as varchar(max)) from openrowset(bulk '''+@file_name+''', single_clob) t(xData)';
        exec sp_executesql @cSql, N'@cXml varchar(max) output', @cXml output;
        -- Select @cXml
    End

	-- ==================================================
	-- ��������������� ���������
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
	-- ������ alleles
	-- ====================================================================================================
	If Object_id('tempdb..#alleles') Is Not Null
	    Drop Table #alleles

	Select *
	       Into #alleles
	    From Openxml(@xml_id ,'/alleles/allele' ,2)
	         With ( [allele_id] Varchar(20) '@id'
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
	-- ������ �������� �� ������
	-- ====================================================================================================
	If Object_id('tempdb..#features') Is Not Null
	    Drop Table #features

	Select *
	       Into #features
	    From Openxml(@xml_id ,'/alleles/allele/sequence/feature' ,2)
	         With (
               [allele_id] Varchar(20) '../../@id'
	          ,[alignmentreference_allelename] Varchar(20) '../alignmentreference/@allelename'
	          ,[alignmentreference_alleleid] Varchar(20) '../alignmentreference/@alleleid'
	          ,[feature_id] Varchar(20) '@id'
	          ,[feature_order] Int '@order'
	          ,[feature_type] Varchar(20) '@featuretype'
	          ,[feature_name] Varchar(20) '@name'
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

	-- �������� �� �����
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

	-- �������� ������
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
            [feature_odrer],
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

	-- ==================================================
	-- ���������� ������
	-- ==================================================
    Print '=================================================='
    Print '*** ������������� hla_uexon'
    Truncate Table hla_uexon

    Insert Into hla_uexon
        (uexon_name
        , uexon_seq)
        Select f.feature_name
			,f.feature_nucsequence
			From hla_features f
			Inner Join hla_alleles a On a.allele_id=f.allele_id          
			where 1=1
				and f.feature_type ='Exon'
				and f.feature_name in ('Exon 2','Exon 3','Exon 4')
				and f.[feature_status]='Complete'
				-- And a.release_confimed='Confirmed'
			Group by f.feature_name,f.feature_nucsequence


	--Declare @xml        Xml
	--       ,@xml_id     Int
	--       ,@seq        Varchar(Max)
 --          ,@cSql       nVarchar(Max)
 --          ,@max_n      Int
 --          ,@n          Int

    Update hla_uexon
        Set uexon_half_iid	= uexon_iid
        	,k_forward_back	= 1


    Print '=================================================='
    Print '*** �������� ��������������� ���������'
    Insert Into hla_uexon
        (uexon_name, uexon_seq, k_forward_back, uexon_half_iid)
        Select
			u.uexon_name
            ,u.uexon_seq
            ,2
            ,u.uexon_half_iid
        From hla_uexon u

	-- �����������
    Update hla_uexon
        Set uexon_seq	= REVERSE(uexon_seq)
        Where k_forward_back = 2

	-- �������� �� ���������������
    -- A->1->T
    -- T->2->A
    -- C->3->G
    -- G->4->C
    Update hla_uexon
        Set uexon_seq	= Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(uexon_seq,'A','1'),'T','2'),'C','3'),'G','4'),'1','T'),'2','A'),'3','G'),'4','C')
        Where k_forward_back = 2


    -- ==================================================
    -- ����� 
    -- ==================================================
    Update hla_uexon
        Set uexon_len_x = Len(uexon_seq)

    Print '=================================================='
    Print '*** ������������� hla_uexon - 0123'
    Select @max_n=Max(len(hw.uexon_seq))
        From hla_uexon hw

    Update hla_uexon
        Set uexon_seq_x = ''

    Update hla_uexon
        Set uexon_seq_x	= Replace(Replace(Replace(Replace(uexon_seq,'A','0'),'C','1'),'G','2'),'T','3')

    --Select @n=1
    --While @n<=@max_n
    --Begin
    --    Print 'hla_uexon x-num step='+Cast(@n As varchar(20))
    --    Update hla_uexon
    --        Set uexon_seq_x=uexon_seq_x+case Substring(uexon_seq,@n,1) When 'A' Then '0' When 'C' Then '1' When 'G' Then '2' When 'T' Then '3' End
    --        Where Len(uexon_seq)>=@n
    --    Select @n=@n+1
    --End

End
