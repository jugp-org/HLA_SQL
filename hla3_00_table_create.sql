SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
-- **************************************************
--  База данных HLA
-- **************************************************
	use master 
    go
    Create Database [DNA2_HLA] On  
		Primary(
			Name = N'DNA2_HLA',
			Filename = N'C:\SQL_DATA\SQL_2008\DNA2_HLA.mdf',
			Size = 3072KB,
			Filegrowth = 1024KB
		)
		Log On 
		(
			Name = N'DNA2_hla3_log',
			Filename = N'C:\SQL_DATA\SQL_2008\DNA2_hla3_log.ldf',
			Size = 1024KB,
			Filegrowth = 10%
		)
	Go
	Alter Database [DNA2_HLA] 
	Set COMPATIBILITY_LEVEL = 100
	Go
	Alter Database [DNA2_HLA] 
	Set Ansi_null_default Off 
	Go
	Alter Database [DNA2_HLA] 
	Set Ansi_nulls Off 
	Go
	Alter Database [DNA2_HLA] 
	Set Ansi_padding Off 
	Go
	Alter Database [DNA2_HLA] 
	Set Ansi_warnings Off 
	Go
	Alter Database [DNA2_HLA] 
	Set Arithabort Off 
	Go
	Alter Database [DNA2_HLA] 
	Set Auto_close Off 
	Go
	Alter Database [DNA2_HLA] 
	Set Auto_create_statistics On 
	Go
	Alter Database [DNA2_HLA] 
	Set Auto_shrink Off 
	Go
	Alter Database [DNA2_HLA] 
	Set Auto_update_statistics On 
	Go
	Alter Database [DNA2_HLA] 
	Set Cursor_close_on_commit Off 
	Go
	Alter Database [DNA2_HLA] 
	Set Cursor_default Global 
	Go
	Alter Database [DNA2_HLA] 
	Set Concat_null_yields_null Off 
	Go
	Alter Database [DNA2_HLA] 
	Set Numeric_roundabort Off 
	Go
	Alter Database [DNA2_HLA] 
	Set Quoted_identifier Off 
	Go
	Alter Database [DNA2_HLA] 
	Set Recursive_triggers Off 
	Go
	Alter Database [DNA2_HLA] 
	Set Disable_broker 
	Go
	Alter Database [DNA2_HLA] 
	Set Auto_update_statistics_async Off 
	Go
	Alter Database [DNA2_HLA] 
	Set Date_correlation_optimization Off 
	Go
	Alter Database [DNA2_HLA] 
	Set Parameterization Simple 
	Go
	Alter Database [DNA2_HLA] 
	Set Read_committed_snapshot Off 
	Go
	Alter Database [DNA2_HLA] 
	Set Read_write 
	Go
	Alter Database [DNA2_HLA] 
	Set Recovery Simple 
	Go
	Alter Database [DNA2_HLA] 
	Set Multi_user 
	Go
	Alter Database [DNA2_HLA] 
	Set Page_verify Checksum  
	Go
	Use [DNA2_HLA]
	Go
	If Not Exists (
		   Select Name
		   From   sys.filegroups
		   Where  is_default     = 1
				  And Name       = N'PRIMARY'
	   )
		Alter Database [DNA2_HLA] Modify Filegroup [PRIMARY] Default
	Go
*/

-- **************************************************
-- Определение таблиц HLA
-- exec [_adm_table_create]
-- **************************************************
/*
    Drop table [hla3_alleles]
    Drop table [hla3_features]
    Drop table hla3_uexon
    Drop table hla3_uexon_part
    Drop table [hla3_uexon_part2]
    Drop table [hla3_uexon_upart]
    Drop table [hla3_fexon_align]
    Drop table [hla3_uexon_ugpart]
    Drop table [hla3_version]
    
*/
	Use [DNA2_HLA]
	SET NOCOUNT ON;

    -- ==================================================
    -- Alleles
    -- ==================================================
    CREATE TABLE [dbo].[hla3_alleles](
	    [allele_iid]				int identity,
	    [allele_id]					varchar(30) Null,
	    [allele_name]				varchar(50),

	    --[allele_dateassigned]		varchar(10),

	    --[release_firstreleased]		varchar(10),
	    --[release_lastupdated]		varchar(10),
	    --[release_currentrelease]	varchar(10),
	    --[release_status]			varchar(20),
	    --[release_confirmed]			varchar(20),


	    --[locus_genesystem]			varchar(10),
	    --[locus_name]				varchar(20),
	    --[locus_hugogenename]		varchar(20),
	    --[locus_class]				varchar(10),

	    --[cwd_status]				varchar(30),
	    --[cwd_version]				varchar(30),
	    --[cwd_reference]				varchar(80),

	    --[sequence_allelename]		varchar(20),
	    --[sequence_alleleid]			varchar(20),
	    --[sequence_nucsequence]		varchar(max)

	    [hla_g_group]				varchar(40),
	    [hla_p_group]				varchar(40)
    )

    -- indexes
    Create nonclustered index [hla3_alleles_idx1] ON [dbo].[hla3_alleles] ([allele_id])
    Create nonclustered index [hla3_alleles_idx2] ON [dbo].[hla3_alleles] ([allele_name])
    -- permissions
    Grant insert,update,delete,select on hla3_alleles to public

    -- ==================================================
    -- Разбиение аллелей на экзоны
    -- ==================================================
    CREATE TABLE [dbo].[hla3_features](
	    [allele_id]					    varchar(30),
	    [feature_iid]				    int identity,
	    [feature_id]				    varchar(30) Null,
	    [feature_type]				    varchar(20),
	    [feature_name]				    varchar(30),
	    [feature_status]			    varchar(10)	Null,

	    --[feature_order]				    int,

	    --[alignmentreference_alleleid]	varchar(30),
	    --[alignmentreference_allelename]	varchar(30),
	    --[SequenceCoordinates_start]	    int	NULL,
	    --[SequenceCoordinates_end]	    int	NULL,

	    --[cDNACoordinates_start]		    int	NULL,
	    --[cDNACoordinates_end]		    int	NULL,

	    --[cDNAindel_start]		        int	NULL,
	    --[cDNAindel_end]		        int	NULL,
	    --[cDNAindel_size]	            int	NULL,
	    --[cDNAindel_type]	            Varchar(20)	Null,

	    [feature_nucsequence]		    varchar(max) Null,
	    [feature_len]		            Int	Null,
	    [feature_diff_first]		    varchar(max) Null

    ) 

    -- indexes
    Create Nonclustered Index [hla3_features_idx1] On [dbo].[hla3_features] ([allele_id] Asc)
    Create Nonclustered Index [hla3_features_idx2] On [dbo].[hla3_features] ([feature_type],[feature_name],[feature_status],[allele_id])
    Grant insert,update,delete,select on [hla3_features] to public


    -- ==================================================
    -- Уникальные Экзоны
    -- ==================================================
    -- drop table hla3_uexon
    -- alter table [hla3_uexon] add [uexon_diff_seq] varchar(max) Null 
    Create Table [dbo].[hla3_uexon]
    (
	    [uexon_iid]					    numeric(15) Not Null Identity (1,1)
	   ,[uexon_uid]					    numeric(15)             -- Уникальный ид. экpона - одинаковый для одинаковых последовательностей и прямого обратного экзона
	   ,[uexon_half_iid]				Int                     -- Ид. одинаковый для двух половинок, для прямого экзона совпадает с uexon_iid
	   ,[uexon_num]	    				numeric(2)              -- Номер экзона
	   ,[uexon_seq]					    varchar(max)            -- 
	   ,[uexon_len]	        		    Int                     -- Длина экзона
       ,[gen_cd]                        varchar(10)             -- код гена HLA-A*, HLA-B*, HLA-C* ... 
       ,[k_forward_back]				Smallint
       ,[epart_cnt]                     numeric(10)     Null
       ,[uexon_diff_seq]                varchar(max)    Null    -- 
    )
    Go
    -- permissions
    Grant Insert,Update,Delete,Select On hla3_uexon To public
    go
    Create Nonclustered Index [hla3_uexon_idx1] On [dbo].[hla3_uexon](uexon_iid)
    Create Nonclustered Index [hla3_uexon_idx2] On [dbo].[hla3_uexon](uexon_iid,k_forward_back)
    Go


    -- ==================================================
    -- Экзоны для выравнивания
    -- Это экзоны первых аллелей для каждой длины экзона
    -- ==================================================
    -- drop table [hla3_fexon_align]
    Create Table [dbo].[hla3_fexon_align]
    (
	    [fexon_iid]					    numeric(15) Not Null Identity (1,1)
	   ,[uexon_iid]					    numeric(15)         -- ид. уникального экзона
	   ,[allele_id]					    varchar(30)
	   ,[allele_name]   			    varchar(50)
       ,[gen_cd]                        varchar(10)         -- код гена HLA-A*, HLA-B*, HLA-C* ... 
	   ,[exon_num]	    				numeric(2)          -- Номер экзона
	   ,[exon_seq]					    varchar(max)        -- 
	   ,[exon_len]	        		    Int                 -- Длина экзона
    )
    Go
    -- permissions
    Grant Insert,Update,Delete,Select On [hla3_fexon_align] To public
    go
















    -- ==================================================
    -- Разбивка экзонов на части
    -- Формируется из hla3_uexon
    -- ==================================================
    -- drop table hla3_uexon_part
    -- alter table hla3_uexon_part drop column uexon_len
    -- alter table hla3_uexon_part add uexon_len Smallint Null
    -- alter table hla3_uexon_part add epart_cnt Smallint Null
    -- alter table hla3_uexon_part add [k_forward_back]    Smallint    Null
    Create Table [dbo].[hla3_uexon_part]
    (
	    [epart_iid]         numeric(15) Not Null Identity (1,1)
	   ,[uexon_iid]  	    numeric(15)
	   ,[epart_hash]        Int
	   ,[epart_pos]         Int
       ,[uexon_len]         Smallint    Null
       ,[epart_cnt]         SmallInt    Null
       ,[k_forward_back]    Smallint    Null

    )
    Go
    -- permissions
    -- drop index hla3_uexon_part_idx2 on [hla3_uexon_part]
    Grant Insert,Update,Delete,Select On [hla3_uexon_part] To public
    go
    Create Nonclustered Index [hla3_uexon_part_idx1] On [dbo].[hla3_uexon_part](epart_hash,epart_pos)
    Create Nonclustered Index [hla3_uexon_part_idx2] On [dbo].[hla3_uexon_part](uexon_iid,epart_pos)
    Go

    -- ==================================================
    -- Уникальные части [hla3_uexon_part]
    -- Формируется из hla3_uexon_part
    -- drop table [hla3_uexon_upart]
    -- ==================================================
    Create Table [dbo].[hla3_uexon_upart]
    (
	    [eupart_iid]        numeric(15) Not Null Identity (1,1)
	   ,[epart_hash]        Int
	   ,[epart_seq]         varchar(12)
    )
    Go
    -- permissions
    -- drop index hla3_uexon_part_idx2 on [hla3_uexon_part]
    Grant Insert,Update,Delete,Select On [hla3_uexon_upart] To public
    go
    Create Nonclustered Index [hla3_uexon_upart_idx1] On [dbo].[hla3_uexon_upart](epart_hash)
    Create Nonclustered Index [hla3_uexon_upart_idx2] On [dbo].[hla3_uexon_upart](epart_seq)
    Go


    -- ==================================================
    -- Уникальные части [hla3_uexon_part]
    -- с точностью до гена и номер аэкзона
    -- Формируется из hla3_uexon_part
    -- drop table [hla3_uexon_upartg]
    -- alter table [hla3_uexon_ugpart] add [k_dbl] Smallint Null
    -- alter table [hla3_uexon_ugpart] add [uexon_cnt] int Null
    -- ==================================================
    Create Table [dbo].[hla3_uexon_ugpart]
    (
	    [eupart_iid]        numeric(15) Not Null Identity (1,1)
	   ,[epart_hash]        Int
	   ,[epart_seq]         varchar(12)
       ,[gen_cd]            varchar(10)
       ,[uexon_num]         Smallint
       ,[k_dbl]             Smallint        -- Ключ принадлежности разным экзонам/генам
       ,[uexon_cnt]         Int             -- Кол-во экзонов в которых найдена часть
    )
    Go
    -- permissions
    -- drop index hla3_uexon_part_idx2 on [hla3_uexon_part]
    Grant Insert,Update,Delete,Select On [hla3_uexon_ugpart] To public
    go
    Create Nonclustered Index [hla3_uexon_ugpart_idx1] On [dbo].[hla3_uexon_ugpart](epart_hash)
    Create Nonclustered Index [hla3_uexon_ugpart_idx2] On [dbo].[hla3_uexon_ugpart](epart_seq)
    Go

    -- Таблица разбивки с каждого символа
    -- drop table hla3_uexon_part2
    Create Table [dbo].[hla3_uexon_part2]
    (
	    [epart_iid]     numeric(15) Not Null Identity (1,1)
	   ,[uexon_iid]  	numeric(15)
	   ,[epart_hash]    int
	   ,[epart_pos]     int
    )
    Go
    -- permissions
    Grant Insert,Update,Delete,Select On [hla3_uexon_part2] To public
    go
    Create Nonclustered Index [hla3_uexon_part2_idx1] On [dbo].[hla3_uexon_part2](epart_hash,epart_pos)
    Create Nonclustered Index [hla3_uexon_part2_idx2] On [dbo].[hla3_uexon_part2](uexon_iid)
    Go

    -- Версия загруженных данных HLA.XML
    Create Table [dbo].[hla3_version]
    (
	    [file_name]     Varchar(250)
	   ,[file_create]  	datetime
	   ,[file_size]  	Numeric(15)
	   ,[file_loaded]   datetime
    )
    Go
    -- permissions
    Grant Insert,Update,Delete,Select On [hla3_version] To public
    Go
