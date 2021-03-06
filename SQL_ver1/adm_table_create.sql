/****** Object:  StoredProcedure [dbo].[_adm_table_create]    Script Date: 28.08.2017 12:16:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


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
	    [feature_len]		            Int	NULL
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


    -- ****************************************************************************************************
    -- Данные из *.fastq
    -- ****************************************************************************************************
    -- ==================================================
    -- reads
    -- ==================================================
    -- drop table [hla_reads]
    Create Table [dbo].[hla_reads]
    (
    	[read_session]      Numeric(15)
       ,[read_file]         Varchar(200)
       ,[read_datetime]     Datetime
       ,[read_sid]          Varchar(20)
       ,[read_data]         Varchar(Max) Null
       ,[read_quality]      Varchar(Max) Null
    ) On [PRIMARY] Textimage_on [PRIMARY]

    -- indexes
    Create Nonclustered Index [hla_reads_idx0] On [dbo].[hla_reads] ([read_sid] Asc)
    Create Nonclustered Index [hla_reads_idx1] On [dbo].[hla_reads] ([read_session] Asc)
        With ( Pad_index=Off
                ,Statistics_norecompute=Off
                ,Sort_in_tempdb=Off
                ,Ignore_dup_key=Off
                ,Drop_existing=Off
                ,Online=Off
                ,Allow_row_locks=On
                ,Allow_page_locks=On ) On [PRIMARY]

    Create Nonclustered Index [hla_reads_idx2] On [dbo].[hla_reads] ([read_file] Asc)
        With ( Pad_index=Off
                ,Statistics_norecompute=Off
                ,Sort_in_tempdb=Off
                ,Ignore_dup_key=Off
                ,Drop_existing=Off
                ,Online=Off
                ,Allow_row_locks=On
                ,Allow_page_locks=On ) On [PRIMARY]

    -- permissions
    Grant Insert,Update,Delete,Select On [hla_reads] To public

    -- ==================================================
    -- reads после обработки
    -- счиатем их ХОРОШИМИ!!!
    -- ==================================================
    -- drop table hla_wreads
    Create Table [dbo].[hla_wreads]
    (
	    [read_iid]			numeric(15) Not Null Identity (1,1)
       ,[read_sid]          Varchar(20)         -- ид. из файла данных
       ,[read_id]           bigint              -- id=hash формируется по [read_sid]
       ,[read_seq]          Varchar(Max) Null   -- строка исходных данных ACGT
       ,[read_qual]         Varchar(Max) Null   -- стока качества
       ,[read_seq_e]        Varchar(Max) Null   -- стока данных ACGT после отсечения ошибок
       ,[read_seq_x]        Varchar(Max) Null   -- строка данных 0123
       ,[read_len_x]        Int          Null   -- длина строки данных read_seq_x
       ,[k_forward_back]	Smallint     Null
    )
    Go
    Create Nonclustered Index [hla_wreads_idx0] On [dbo].[hla_wreads] ([read_sid] Asc)
    Create Nonclustered Index [hla_wreads_idx1] On [dbo].[hla_wreads] ([read_id] Asc)
    Create Nonclustered Index [hla_wreads_idx2] On [dbo].[hla_wreads] ([read_iid] Asc)
    Go
    -- permissions
    Grant Insert,Update,Delete,Select On [hla_wreads] To public
    Go

    -- ==================================================
    -- Разбивка reads на части
    -- Формируется из [hla_reads]
    -- ==================================================
    -- drop table hla_reads_part
    Create Table [dbo].hla_reads_part
    (
	    [rpart_iid]			numeric(15) Not Null Identity (1,1)
	   ,[rpart_id]			int             -- id=hash формируется по [rpart_seq_x]
       ,[read_id]           Bigint          -- id=hash
       ,[read_iid]          Numeric(15)
	   ,[rpart_pos]         int
	   ,[rpart_seq_x]       varchar(50)
    )
    Go
    -- permissions
    Grant Insert,Update,Delete,Select On hla_reads_part To public
    go
    Create Nonclustered Index [hla_reads_part_idx1] On [dbo].hla_reads_part(rpart_id)
    Create Nonclustered Index [hla_reads_part_idx2] On [dbo].hla_reads_part(read_iid,rpart_pos)
    Create Nonclustered Index [hla_reads_part_idx3] On [dbo].hla_reads_part([rpart_seq_x])
    Go
    -- Drop Index [hla_uexon_part_idx3] On [dbo].hla_reads_part
    -- Create Nonclustered Index [hla_uexon_idx2] On [dbo].[hla_uexon]([uexon_seq])

    -- ==================================================
    -- Уникальные части reads
    -- Формируется из [hla_reads_part]
    -- ==================================================
    -- drop table hla_reads_upart
    Create Table [dbo].hla_reads_upart
    (
        [urpart_iid]        numeric(15) Not Null Identity (1,1)
	   ,[urpart_cnt]        Int
	   ,[urpart_seq_x]      varchar(50)
	   ,[rpart_id]          Int
    )
    Go
    -- permissions
    Grant Insert,Update,Delete,Select On hla_reads_upart To public
    go
    Create Nonclustered Index [hla_reads_upart_idx1] On [dbo].hla_reads_upart([urpart_iid])
    Create Nonclustered Index [hla_reads_upart_idx2] On [dbo].hla_reads_upart(rpart_id)
    Create Nonclustered Index [hla_reads_upart_idx3] On [dbo].hla_reads_upart([urpart_cnt])
    Go
    -- Create Nonclustered Index [hla_uexon_idx2] On [dbo].[hla_uexon]([uexon_seq])


END
