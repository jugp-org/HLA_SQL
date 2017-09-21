USE [HLA]
GO

/****** Object:  Table [dbo].[Batch]    Script Date: 08/14/2017 23:34:33 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[NSeq]') AND type in (N'U'))
DROP TABLE [dbo].[NSeq]
GO

USE [HLA]
GO

/****** Object:  Table [dbo].[Batch]    Script Date: 08/14/2017 23:34:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

/*
	drop table hla_alleles
	drop table hla_features
*/


---------------------------------------------
-- alleles
---------------------------------------------
CREATE TABLE [dbo].[hla_alleles](
	[allele_id]					varchar(20),
	[allele_name]				varchar(20),
	[allele_dateassigned]		varchar(10),
	
	[release_firstreleased]		varchar(10),
	[release_lastupdated]		varchar(10),
	[release_currentrelease]	varchar(10),
	[release_status]			varchar(20),
	[release_confimed]			varchar(20),
	
	[hla_g_group]				varchar(20),
	[hla_p_group]				varchar(20),
	
	[locus_genesystem]			varchar(10),
	[locus_name]				varchar(20),
	[locus_hugogenename]		varchar(20),
	[locus_class]				varchar(10),
	
	[cwd_status]				varchar(30),
	[cwd_version]				varchar(30),
	[cwd_reference]				varchar(80),
	
	[sequence_allelename]		varchar(20),
	[sequence_alleleid]			varchar(20),
	[sequence_nucsequence]		varchar(max)
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

-- indexes
CREATE NONCLUSTERED INDEX [hla_alleles_idx1] ON [dbo].[hla_alleles] 
(
	[allele_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

-- permissions
Grant insert,update,delete,select on hla_alleles to public

---------------------------------------------
-- features of sequenses
---------------------------------------------
CREATE TABLE [dbo].[hla_features](
	[allele_id]					varchar(20),
	
	[alignmentreference_alleleid]	varchar(20),
	[alignmentreference_allelename]	varchar(20),
	
	[feature_id]				varchar(20),
	[feature_odrer]				int,
	[feature_type]				varchar(20),
	[feature_name]				varchar(20),
	[feature_status]			varchar(10)	NULL,
	
	[SequenceCoordinates_start]	int	NULL,
	[SequenceCoordinates_end]	int	NULL,
	
	[cDNACoordinates_start]		int	NULL,
	[cDNACoordinates_end]		int	NULL,
	
	[feature_nucsequence]		varchar(max)	NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

-- indexes
Create Nonclustered Index [hla_features_idx1] On [dbo].[hla_features] ([allele_id] Asc)
    With ( Pad_index=Off
          ,Statistics_norecompute=Off
          ,Sort_in_tempdb=Off
          ,Ignore_dup_key=Off
          ,Drop_existing=Off
          ,Online=Off
          ,Allow_row_locks=On
          ,Allow_page_locks=On ) On [PRIMARY]
GO

-- permissions
Grant insert,update,delete,select on [hla_features] to public


---------------------------------------------
-- reads
---------------------------------------------
CREATE TABLE [dbo].[hla_reads](
	[read_session]	numeric(15),
	[read_file]		varchar(100),
	[read_datetime]	datetime,
	[read_id]		varchar(20),
	[read_data]		varchar(max)	NULL,
	[read_quality]	varchar(max)	NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

-- indexes
CREATE NONCLUSTERED INDEX [hla_reads_idx1] ON [dbo].[hla_reads] 
(
	[read_session] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [hla_reads_idx2] ON [dbo].[hla_reads] 
(
	[read_file] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

-- permissions
Grant insert,update,delete,select on [hla_reads] to public





select count(*) from [hla_alleles] with (nolock)
select count(*) from [hla_features] with (nolock)


select len(rtrim(sequence_nucsequence)),* from [hla_alleles] with (nolock) order by len(rtrim(sequence_nucsequence)) desc
select len(rtrim(feature_nucsequence)),* from [hla_features] with (nolock) where feature_type='exon' order by len(rtrim(feature_nucsequence)) desc
select len(rtrim(feature_nucsequence)),* from [hla_features] with (nolock) where feature_name='Exon 2' and allele_id='HLA00001' order by len(rtrim(feature_nucsequence)) desc
