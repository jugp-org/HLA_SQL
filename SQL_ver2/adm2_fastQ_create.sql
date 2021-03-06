/****** Object:  StoredProcedure [dbo].[_adm_table_create]    Script Date: 28.08.2017 12:16:06 ******/
	SET ANSI_NULLS ON
	GO
	SET QUOTED_IDENTIFIER ON
	GO

/*

	-- **************************************************
	-- Создать базу данных FastQ
	-- **************************************************
	Use [master]
	Go

	Create Database [DNA2_FASTQ] 
		On Primary(
					  Name = N'DNA2_FASTQ',
					  Filename = N'C:\SQL_DATA\SQL_2008\DNA2_FASTQ.mdf',
					  Size = 3072KB,
					  Maxsize = Unlimited,
					  Filegrowth = 1024KB
				  )
	Log On 
				(
					Name = N'DNA2_FASTQ_log',
					Filename = N'C:\SQL_DATA\SQL_2008\DNA2_FASTQ_log.ldf',
					Size = 1024KB,
					Maxsize = 2048GB,
					Filegrowth = 10%
				)
	Go

	Alter Database [DNA2_FASTQ] 
	Set COMPATIBILITY_LEVEL = 100
	Go

	If (1 = Fulltextserviceproperty('IsFullTextInstalled'))
	Begin
		Exec [DNA2_FASTQ].[dbo].[sp_fulltext_database] @action = 'enable'
	End
	Go

	Alter Database [DNA2_FASTQ] 
	Set Ansi_null_default Off 
	Go

	Alter Database [DNA2_FASTQ] 
	Set Ansi_nulls Off 
	Go

	Alter Database [DNA2_FASTQ] 
	Set Ansi_padding Off 
	Go

	Alter Database [DNA2_FASTQ] 
	Set Ansi_warnings Off 
	Go

	Alter Database [DNA2_FASTQ] 
	Set Arithabort Off 
	Go

	Alter Database [DNA2_FASTQ] 
	Set Auto_close Off 
	Go

	Alter Database [DNA2_FASTQ] 
	Set Auto_create_statistics On 
	Go

	Alter Database [DNA2_FASTQ] 
	Set Auto_shrink Off 
	Go

	Alter Database [DNA2_FASTQ] 
	Set Auto_update_statistics On 
	Go

	Alter Database [DNA2_FASTQ] 
	Set Cursor_close_on_commit Off 
	Go

	Alter Database [DNA2_FASTQ] 
	Set Cursor_default Global 
	Go

	Alter Database [DNA2_FASTQ] 
	Set Concat_null_yields_null Off 
	Go

	Alter Database [DNA2_FASTQ] 
	Set Numeric_roundabort Off 
	Go

	Alter Database [DNA2_FASTQ] 
	Set Quoted_identifier Off 
	Go

	Alter Database [DNA2_FASTQ] 
	Set Recursive_triggers Off 
	Go

	Alter Database [DNA2_FASTQ] 
	Set Disable_broker 
	Go

	Alter Database [DNA2_FASTQ] 
	Set Auto_update_statistics_async Off 
	Go

	Alter Database [DNA2_FASTQ] 
	Set Date_correlation_optimization Off 
	Go

	Alter Database [DNA2_FASTQ] 
	Set Trustworthy Off 
	Go

	Alter Database [DNA2_FASTQ] 
	Set Allow_snapshot_isolation Off 
	Go

	Alter Database [DNA2_FASTQ] 
	Set Parameterization Simple 
	Go

	Alter Database [DNA2_FASTQ] 
	Set Read_committed_snapshot Off 
	Go

	Alter Database [DNA2_FASTQ] 
	Set HONOR_BROKER_PRIORITY Off 
	Go

	Alter Database [DNA2_FASTQ] 
	Set Recovery Simple 
	Go

	Alter Database [DNA2_FASTQ] 
	Set Multi_user 
	Go

	Alter Database [DNA2_FASTQ] 
	Set Page_verify Checksum  
	Go

	Alter Database [DNA2_FASTQ] 
	Set Db_chaining Off 
	Go

	Alter Database [DNA2_FASTQ] 
	Set Read_write 
	Go

*/

-- **************************************************
-- Определение таблиц 
-- **************************************************
/*
    Drop table [hla_reads]
    Drop table [hla_wreads]
    Drop table hla_reads_part
    Drop table hla_reads_upart
    
*/
	Use [DNA2_FASTQ]
	SET NOCOUNT ON;
	Go
	
    -- ****************************************************************************************************
    -- Данные из *.fastq
    -- ****************************************************************************************************
    -- ==================================================
    -- reads
    -- ==================================================
    -- drop table [hla_reads]
    Create Table [dbo].[hla_reads]
    (
         [read_iid]			numeric(15) Not Null Identity (1,1)
        ,[read_session]     Numeric(15)
        ,[read_file]        Varchar(200)
        ,[read_datetime]    Datetime
        ,[read_cd]          Varchar(20)
        ,[read_hash]        bigint       Null   -- id=hash формируется по [read_cd]
        ,[read_seq]         Varchar(Max) Null
        ,[read_qual]        Varchar(Max) Null  -- стока качества
        ,[read_len]         Int          Null   -- длина строки данных read_seq_x
        ,[k_forward_back]	Smallint     Null
    ) On [PRIMARY] Textimage_on [PRIMARY]
    Go

    -- indexes
    Create Nonclustered Index [hla_reads_idx0] On [dbo].[hla_reads] ([read_cd] Asc)
    Create Nonclustered Index [hla_reads_idx1] On [dbo].[hla_reads] ([read_hash] Asc)
    Create Nonclustered Index [hla_reads_idx2] On [dbo].[hla_reads] ([read_iid] Asc)

    -- permissions
    Grant Insert,Update,Delete,Select On [hla_reads] To public
    Go

    -- ==================================================
    -- Разбивка reads на части
    -- Формируется из [hla_reads]
    -- ==================================================
    -- drop table hla_reads_part
    Create Table [dbo].hla_reads_part
    (
	    [rpart_iid]			numeric(15) Not Null Identity (1,1)
	   ,[rpart_hash]        int             -- id=hash формируется по [rpart_seq]
       ,[read_iid]          Numeric(15)
	   ,[rpart_pos]         int
    )
    Go
    -- permissions
    Grant Insert,Update,Delete,Select On hla_reads_part To public
    go
    Create Nonclustered Index [hla_reads_part_idx1] On [dbo].hla_reads_part(rpart_hash)
    Create Nonclustered Index [hla_reads_part_idx2] On [dbo].hla_reads_part(read_iid,rpart_pos)
    Go
    -- Drop Index [hla_uexon_part_idx3] On [dbo].hla_reads_part
    -- Create Nonclustered Index [hla_uexon_idx2] On [dbo].[hla_uexon]([uexon_seq])

    ---- ==================================================
    ---- Уникальные части reads
    ---- Формируется из [hla_reads_part]
    ---- ==================================================
    -- drop table hla_reads_upart
    Create Table [dbo].hla_reads_upart
    (
        [urpart_iid]        numeric(15) Not Null Identity (1,1)
	   ,[urpart_cnt]        Int
	   ,[rpart_hash]        Int
       ,k_ex                Smallint
    )
    Go
    -- permissions
    Grant Insert,Update,Delete,Select On hla_reads_upart To public
    go
    Create Nonclustered Index [hla_reads_upart_idx1] On [dbo].hla_reads_upart([urpart_iid])
    Create Nonclustered Index [hla_reads_upart_idx2] On [dbo].hla_reads_upart(rpart_hash)
    Go


