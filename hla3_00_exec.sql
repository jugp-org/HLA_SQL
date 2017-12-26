-- ==================================================
-- Загрузка .nuc файлов
-- ==================================================
Truncate Table [hla3_alleles]
Truncate Table [hla3_features]

-- ==================================================
-- 
-- ==================================================
Declare @fmt_file    Varchar(250)
Select @fmt_file    = 'C:\WORK\PROJECT\HLA_PROJ\NGS_DATA\ftp_data\_nuc.fmt'

Exec [hla3_Nuc_Read] @file_name=N'C:\WORK\PROJECT\HLA_PROJ\NGS_DATA\ftp_data\A_nuc.txt', @fmt_name=@fmt_file, @exon_cnt=3
Exec [hla3_Nuc_Read] @file_name=N'C:\WORK\PROJECT\HLA_PROJ\NGS_DATA\ftp_data\B_nuc.txt', @fmt_name=@fmt_file, @exon_cnt=3
Exec [hla3_Nuc_Read] @file_name=N'C:\WORK\PROJECT\HLA_PROJ\NGS_DATA\ftp_data\C_nuc.txt', @fmt_name=@fmt_file, @exon_cnt=3

Exec [hla3_Nuc_Read] @file_name=N'C:\WORK\PROJECT\HLA_PROJ\NGS_DATA\ftp_data\DPB1_nuc.txt', @fmt_name=@fmt_file, @exon_cnt=2
Exec [hla3_Nuc_Read] @file_name=N'C:\WORK\PROJECT\HLA_PROJ\NGS_DATA\ftp_data\DQB1_nuc.txt', @fmt_name=@fmt_file, @exon_cnt=2
Exec [hla3_Nuc_Read] @file_name=N'C:\WORK\PROJECT\HLA_PROJ\NGS_DATA\ftp_data\DRB_nuc.txt',  @fmt_name=@fmt_file, @exon_cnt=2

Exec [hla3_Nuc_Read] @file_name=N'C:\WORK\PROJECT\HLA_PROJ\NGS_DATA\ftp_data\DMA_nuc.txt',  @fmt_name=@fmt_file, @exon_cnt=2
Exec [hla3_Nuc_Read] @file_name=N'C:\WORK\PROJECT\HLA_PROJ\NGS_DATA\ftp_data\DMB_nuc.txt',  @fmt_name=@fmt_file, @exon_cnt=2
Exec [hla3_Nuc_Read] @file_name=N'C:\WORK\PROJECT\HLA_PROJ\NGS_DATA\ftp_data\DOA_nuc.txt',  @fmt_name=@fmt_file, @exon_cnt=2
Exec [hla3_Nuc_Read] @file_name=N'C:\WORK\PROJECT\HLA_PROJ\NGS_DATA\ftp_data\DOB_nuc.txt',  @fmt_name=@fmt_file, @exon_cnt=2
Exec [hla3_Nuc_Read] @file_name=N'C:\WORK\PROJECT\HLA_PROJ\NGS_DATA\ftp_data\DPA1_nuc.txt', @fmt_name=@fmt_file, @exon_cnt=2
Exec [hla3_Nuc_Read] @file_name=N'C:\WORK\PROJECT\HLA_PROJ\NGS_DATA\ftp_data\DPA2_nuc.txt', @fmt_name=@fmt_file, @exon_cnt=2
Exec [hla3_Nuc_Read] @file_name=N'C:\WORK\PROJECT\HLA_PROJ\NGS_DATA\ftp_data\DPB2_nuc.txt', @fmt_name=@fmt_file, @exon_cnt=2
Exec [hla3_Nuc_Read] @file_name=N'C:\WORK\PROJECT\HLA_PROJ\NGS_DATA\ftp_data\DQA1_nuc.txt', @fmt_name=@fmt_file, @exon_cnt=2
Exec [hla3_Nuc_Read] @file_name=N'C:\WORK\PROJECT\HLA_PROJ\NGS_DATA\ftp_data\DRA_nuc.txt',  @fmt_name=@fmt_file, @exon_cnt=2

Exec [hla3_Nuc_Read] @file_name=N'C:\WORK\PROJECT\HLA_PROJ\NGS_DATA\ftp_data\E_nuc.txt', @fmt_name=@fmt_file, @exon_cnt=3
Exec [hla3_Nuc_Read] @file_name=N'C:\WORK\PROJECT\HLA_PROJ\NGS_DATA\ftp_data\F_nuc.txt', @fmt_name=@fmt_file, @exon_cnt=3
Exec [hla3_Nuc_Read] @file_name=N'C:\WORK\PROJECT\HLA_PROJ\NGS_DATA\ftp_data\G_nuc.txt', @fmt_name=@fmt_file, @exon_cnt=3
Exec [hla3_Nuc_Read] @file_name=N'C:\WORK\PROJECT\HLA_PROJ\NGS_DATA\ftp_data\H_nuc.txt', @fmt_name=@fmt_file, @exon_cnt=3
Exec [hla3_Nuc_Read] @file_name=N'C:\WORK\PROJECT\HLA_PROJ\NGS_DATA\ftp_data\HFE_nuc.txt', @fmt_name=@fmt_file, @exon_cnt=2
Exec [hla3_Nuc_Read] @file_name=N'C:\WORK\PROJECT\HLA_PROJ\NGS_DATA\ftp_data\J_nuc.txt', @fmt_name=@fmt_file, @exon_cnt=3
Exec [hla3_Nuc_Read] @file_name=N'C:\WORK\PROJECT\HLA_PROJ\NGS_DATA\ftp_data\K_nuc.txt', @fmt_name=@fmt_file, @exon_cnt=3
Exec [hla3_Nuc_Read] @file_name=N'C:\WORK\PROJECT\HLA_PROJ\NGS_DATA\ftp_data\L_nuc.txt', @fmt_name=@fmt_file, @exon_cnt=3
Exec [hla3_Nuc_Read] @file_name=N'C:\WORK\PROJECT\HLA_PROJ\NGS_DATA\ftp_data\MICA_nuc.txt', @fmt_name=@fmt_file, @exon_cnt=2
Exec [hla3_Nuc_Read] @file_name=N'C:\WORK\PROJECT\HLA_PROJ\NGS_DATA\ftp_data\MICB_nuc.txt', @fmt_name=@fmt_file, @exon_cnt=2
Exec [hla3_Nuc_Read] @file_name=N'C:\WORK\PROJECT\HLA_PROJ\NGS_DATA\ftp_data\T_nuc.txt', @fmt_name=@fmt_file, @exon_cnt=3
Exec [hla3_Nuc_Read] @file_name=N'C:\WORK\PROJECT\HLA_PROJ\NGS_DATA\ftp_data\TAP1_nuc.txt', @fmt_name=@fmt_file, @exon_cnt=2
Exec [hla3_Nuc_Read] @file_name=N'C:\WORK\PROJECT\HLA_PROJ\NGS_DATA\ftp_data\TAP2_nuc.txt', @fmt_name=@fmt_file, @exon_cnt=2
Exec [hla3_Nuc_Read] @file_name=N'C:\WORK\PROJECT\HLA_PROJ\NGS_DATA\ftp_data\V_nuc.txt', @fmt_name=@fmt_file, @exon_cnt=3
Exec [hla3_Nuc_Read] @file_name=N'C:\WORK\PROJECT\HLA_PROJ\NGS_DATA\ftp_data\W_nuc.txt', @fmt_name=@fmt_file, @exon_cnt=3
Exec [hla3_Nuc_Read] @file_name=N'C:\WORK\PROJECT\HLA_PROJ\NGS_DATA\ftp_data\Y_nuc.txt', @fmt_name=@fmt_file, @exon_cnt=3

-- ==================================================
-- Загрузка ид. аллелей
-- ftp://ftp.ebi.ac.uk/pub/databases/ipd/imgt/hla/Allelelist.txt
-- ==================================================
Declare @fmt_file    Varchar(250)
Select @fmt_file    = 'C:\WORK\PROJECT\HLA_PROJ\NGS_DATA\ftp_data\_allele.fmt'

exec hla3_Allele_Read
     @file_name  = 'C:\WORK\PROJECT\HLA_PROJ\NGS_DATA\ftp_data\Allelelist.txt'
    ,@fmt_name  = @fmt_file


-- ==================================================
-- Загрузка групп аллелей
-- ftp://ftp.ebi.ac.uk/pub/databases/ipd/imgt/hla/wmda/
-- ==================================================
Declare @fmt_file    Varchar(250)
Select @fmt_file    = 'C:\WORK\PROJECT\HLA_PROJ\NGS_DATA\ftp_data\_group.fmt'

exec hla3_Group_Read
    @file_name  = 'C:\WORK\PROJECT\HLA_PROJ\NGS_DATA\ftp_data\hla_nom_g.txt'
    ,@fmt_name  = @fmt_file
    ,@file_type = 'G'

exec hla3_Group_Read
    @file_name  = 'C:\WORK\PROJECT\HLA_PROJ\NGS_DATA\ftp_data\hla_nom_p.txt'
    ,@fmt_name  = @fmt_file
    ,@file_type = 'P'

-- ==================================================
-- Инициализация uExon
-- ==================================================
Exec [hla3_Exon_Init]

-- ==================================================
-- Расчет hash
-- ==================================================
Exec [hla3_Hash_create]

-- ==================================================
-- Alignment
-- ==================================================
Exec [hla3_Exon_Align]

