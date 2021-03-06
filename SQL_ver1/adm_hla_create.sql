SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
-- **************************************************
--  База данных HLA
-- **************************************************
	Create Database [DNA_HLA] On  
		Primary(
			Name = N'DNA_HLA',
			Filename = N'C:\SQL_DATA\SQL_2008\DNA_HLA.mdf',
			Size = 3072KB,
			Filegrowth = 1024KB
		)
		Log On 
		(
			Name = N'DNA_HLA_log',
			Filename = N'C:\SQL_DATA\SQL_2008\DNA_HLA_log.ldf',
			Size = 1024KB,
			Filegrowth = 10%
		)
	Go
	Alter Database [DNA_HLA] 
	Set COMPATIBILITY_LEVEL = 100
	Go
	Alter Database [DNA_HLA] 
	Set Ansi_null_default Off 
	Go
	Alter Database [DNA_HLA] 
	Set Ansi_nulls Off 
	Go
	Alter Database [DNA_HLA] 
	Set Ansi_padding Off 
	Go
	Alter Database [DNA_HLA] 
	Set Ansi_warnings Off 
	Go
	Alter Database [DNA_HLA] 
	Set Arithabort Off 
	Go
	Alter Database [DNA_HLA] 
	Set Auto_close Off 
	Go
	Alter Database [DNA_HLA] 
	Set Auto_create_statistics On 
	Go
	Alter Database [DNA_HLA] 
	Set Auto_shrink Off 
	Go
	Alter Database [DNA_HLA] 
	Set Auto_update_statistics On 
	Go
	Alter Database [DNA_HLA] 
	Set Cursor_close_on_commit Off 
	Go
	Alter Database [DNA_HLA] 
	Set Cursor_default Global 
	Go
	Alter Database [DNA_HLA] 
	Set Concat_null_yields_null Off 
	Go
	Alter Database [DNA_HLA] 
	Set Numeric_roundabort Off 
	Go
	Alter Database [DNA_HLA] 
	Set Quoted_identifier Off 
	Go
	Alter Database [DNA_HLA] 
	Set Recursive_triggers Off 
	Go
	Alter Database [DNA_HLA] 
	Set Disable_broker 
	Go
	Alter Database [DNA_HLA] 
	Set Auto_update_statistics_async Off 
	Go
	Alter Database [DNA_HLA] 
	Set Date_correlation_optimization Off 
	Go
	Alter Database [DNA_HLA] 
	Set Parameterization Simple 
	Go
	Alter Database [DNA_HLA] 
	Set Read_committed_snapshot Off 
	Go
	Alter Database [DNA_HLA] 
	Set Read_write 
	Go
	Alter Database [DNA_HLA] 
	Set Recovery Simple 
	Go
	Alter Database [DNA_HLA] 
	Set Multi_user 
	Go
	Alter Database [DNA_HLA] 
	Set Page_verify Checksum  
	Go
	Use [DNA_HLA]
	Go
	If Not Exists (
		   Select Name
		   From   sys.filegroups
		   Where  is_default     = 1
				  And Name       = N'PRIMARY'
	   )
		Alter Database [DNA_HLA] Modify Filegroup [PRIMARY] Default
	Go
*/

-- **************************************************
-- Определение таблиц HLA
-- exec [_adm_table_create]
-- **************************************************
/*
    Drop table [hla_alleles]
    Drop table [hla_features]
    Drop table hla_uexon
    Drop table hla_uexon_part
    Drop table [hla_uexon_part2]
    Drop table [hla_uexon_upart]
    Drop table [hla_reads]
    Drop table [hla_wreads]
    Drop table hla_reads_part
    Drop table hla_reads_upart
    
*/
	Use [DNA_HLA]
	SET NOCOUNT ON;

    -- ****************************************************************************************************
    -- Данные из hla.xml
    -- ****************************************************************************************************
    -- ==================================================
    -- Alleles
    -- ==================================================
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

    -- indexes
    CREATE NONCLUSTERED INDEX [hla_alleles_idx1] ON [dbo].[hla_alleles] ([allele_id])
        WITH (Pad_index = Off
            , STATISTICS_NORECOMPUTE  = Off
            , SORT_IN_TEMPDB = Off
            , IGNORE_DUP_KEY = Off
            , DROP_EXISTING = Off
            , ONLINE = Off
            , ALLOW_ROW_LOCKS  = On
            , ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

    -- permissions
    Grant insert,update,delete,select on hla_alleles to public

    -- ==================================================
    -- Разбиение аллелей
    -- ==================================================
    -- Drop table [hla_features]
    -- Alter table [hla_features] add  [feature_diff_all]		        varchar(max) Null
    CREATE TABLE [dbo].[hla_features](
	    [allele_id]					    varchar(20),

	    [alignmentreference_alleleid]	varchar(20),
	    [alignmentreference_allelename]	varchar(20),

	    [feature_id]				    varchar(20),
	    [feature_odrer]				    int,
	    [feature_type]				    varchar(20),
	    [feature_name]				    varchar(20),
	    [feature_status]			    varchar(10)	NULL,

	    [SequenceCoordinates_start]	    int	NULL,
	    [SequenceCoordinates_end]	    int	NULL,

	    [cDNACoordinates_start]		    int	NULL,
	    [cDNACoordinates_end]		    int	NULL,

	    [cDNAindel_start]		        int	NULL,
	    [cDNAindel_end]		            int	NULL,
	    [cDNAindel_size]	            int	NULL,
	    [cDNAindel_type]	            Varchar(20)	NULL,

	    [feature_nucsequence]		    varchar(max) Null,
	    [feature_diff_all]		        varchar(max) Null,
	    [feature_len]		            Int	Null
    ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

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

    -- Drop Index [hla_features].[hla_features_idx2]
    Create Nonclustered Index [hla_features_idx2] On [dbo].[hla_features] ([feature_type],[feature_name],[feature_status],[allele_id])


    -- ==================================================
    -- Уникальные Экзоны
    -- ==================================================
    -- Alter table [hla_uexon] add [epart_cnt] numeric(10,2) Null
    -- drop table hla_uexon
    Create Table [dbo].[hla_uexon]
    (
	    [uexon_iid]					    numeric(15) Not Null Identity (1,1)
	   ,[uexon_half_iid]				Int
	   ,[uexon_name]					varchar(20)
	   ,[uexon_seq]					    varchar(max)
	   ,[uexon_seq_x]	    		    varchar(max)
	   ,[uexon_len_x]	    		    Int
       ,[k_forward_back]				Smallint
       ,[epart_cnt]                     numeric(10,2)  Null
    )
    Go
    -- permissions
    Grant Insert,Update,Delete,Select On hla_uexon To public
    go
    Create Nonclustered Index [hla_uexon_idx1] On [dbo].[hla_uexon](uexon_iid)
    Create Nonclustered Index [hla_uexon_idx2] On [dbo].[hla_uexon](uexon_iid,k_forward_back)
    Go
    -- Create Nonclustered Index [hla_uexon_idx2] On [dbo].[hla_uexon]([uexon_seq])

    -- ==================================================
    -- Разбивка экзонов на части
    -- Формируется из hla_uexon
    -- ==================================================
    -- drop table hla_uexon_part
    Create Table [dbo].[hla_uexon_part]
    (
	    [epart_iid]     numeric(15) Not Null Identity (1,1)
	   ,[uexon_iid]  	numeric(15)
	   ,[epart_id]      int
	   ,[epart_pos]     int
	   ,[epart_seq_x]   varchar(50) Null
    )
    Go
    -- permissions
    -- drop index hla_uexon_part_idx2 on [hla_uexon_part]
    Grant Insert,Update,Delete,Select On [hla_uexon_part] To public
    go
    Create Nonclustered Index [hla_uexon_part_idx1] On [dbo].[hla_uexon_part](epart_id,epart_pos)
    Create Nonclustered Index [hla_uexon_part_idx2] On [dbo].[hla_uexon_part](uexon_iid,epart_pos)
    Create Nonclustered Index [hla_uexon_part_idx3] On [dbo].[hla_uexon_part]([epart_seq_x])
    Go

    -- Таблица разбивки с каждого символа
    -- drop table hla_uexon_part2
    Create Table [dbo].[hla_uexon_part2]
    (
	    [epart_iid]     numeric(15) Not Null Identity (1,1)
	   ,[uexon_iid]  	numeric(15)
	   ,[epart_id]      int
	   ,[epart_pos]     int
	   ,[epart_seq_x]   varchar(50) Null
    )
    Go
    -- permissions
    Grant Insert,Update,Delete,Select On [hla_uexon_part2] To public
    go
    Create Nonclustered Index [hla_uexon_part2_idx1] On [dbo].[hla_uexon_part2](epart_id,epart_pos)
    Create Nonclustered Index [hla_uexon_part2_idx2] On [dbo].[hla_uexon_part2](uexon_iid)
    Create Nonclustered Index [hla_uexon_part2_idx3] On [dbo].[hla_uexon_part2]([epart_seq_x])
    Go

    -- ==================================================
    -- Уникальные части экзонов
    -- Формируется из hla_uexon_part
    -- ==================================================
    -- drop table hla_uexon_upart
    Create Table [dbo].[hla_uexon_upart]
    (
	    [upart_iid]     numeric(15) Not Null Identity (1,1)
	   ,[epart_seq]     varchar(50)
    )
    Go
    -- permissions
    Grant Insert,Update,Delete,Select On [hla_uexon_upart] To public
    go
    Create Nonclustered Index [hla_uexon_upart_idx3] On [dbo].[hla_uexon_upart]([epart_seq])
    Go
    -- Create Nonclustered Index [hla_uexon_idx2] On [dbo].[hla_uexon]([uexon_seq])


