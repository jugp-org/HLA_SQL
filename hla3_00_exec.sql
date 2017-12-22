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
-- 
-- ==================================================
Truncate Table [hla3_alleles]
Truncate Table [hla3_features]

-- ==================================================
-- Загрузка
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
-- Check alleles
-- ==================================================
Select a.*
    From hla3_alleles a
    Order By a.allele_name

Select a.allele_name
        ,f.*
    From hla3_alleles a
    Inner Join hla3_features f With (Nolock) On f.allele_id=a.allele_iid
    Order By a.allele_name

-- Проверка на HLA базу
-- Список уникальных экзонов 
-- в привязке к исходным данным
Select f.allele_id
        ,a.allele_name
        ,f.feature_name
        ,na.allele_name
        ,ne.feature_name
        ,ne.feature_nucsequence
        ,f.feature_nucsequence
    From dna2_hla.dbo.hla_features f With (Nolock)
        Inner Join dna2_hla.dbo.[hla_alleles] a With (Nolock) On a.allele_id=f.allele_id
        left Join hla3_alleles na With (Nolock) On na.allele_name=a.allele_name
        left Join hla3_features ne With (Nolock) 
            on 1=1
            And ne.feature_name=f.feature_name
            And ne.feature_nucsequence=f.feature_nucsequence 
            And ne.allele_id=na.allele_id
    Where 1=1
            -- And (a.allele_name Like 'HLA-A*%' Or a.allele_name Like 'HLA-B*%' Or a.allele_name Like 'HLA-C*%')
            And f.feature_name In ('Exon 2','Exon 3','Exon 4')
            And Isnull(na.allele_name,'')=''
            --And na.allele_name In (
            --    'HLA-A*03:200Q'
            --    ,'HLA-A*03:200Q'
            --    ,'HLA-A*03:200Q'
            --    ,'HLA-A*03:260'
            --    ,'HLA-A*03:260'
            --    ,'HLA-A*03:260'
            --    ,'HLA-A*33:03:01'
            --    ,'HLA-A*33:03:01'
            --    ,'HLA-A*33:03:01'
            --    ,'HLA-B*15:30'
            --    ,'HLA-B*15:30'
            --    ,'HLA-B*15:30'
            --    ,'HLA-B*18:131'
            --    ,'HLA-B*18:131'
            --    ,'HLA-B*18:131'
            --    ,'HLA-B*27:12'
            --    ,'HLA-B*27:12'
            --    ,'HLA-B*27:12'
            --    ,'HLA-B*37:01:01'
            --    ,'HLA-B*37:01:01'
            --    ,'HLA-B*37:01:01'
            --    ,'HLA-B*40:298'
            --    ,'HLA-B*40:298'
            --    ,'HLA-B*52:21'
            --    ,'HLA-B*52:21'
            --    ,'HLA-B*57:01:01'
            --    ,'HLA-B*57:01:01'
            --    ,'HLA-B*57:01:01'
            --    ,'HLA-C*07:04:02'
            --    ,'HLA-C*07:04:02'
            --    ,'HLA-C*07:04:02'
            --    ,'HLA-C*07:109'
            --    ,'HLA-C*07:109'
            --)
    Order By a.allele_name,f.feature_name,f.alignmentreference_alleleid 


-- Проверка групп
Select a.allele_name
        ,a.hla_g_group
        ,a.hla_p_group
        ,na.allele_name
        ,na.hla_g_group
        ,na.hla_p_group
    From dna2_hla.dbo.[hla_alleles] a With (Nolock) 
        left Join hla3_alleles na With (Nolock) On na.allele_name=a.allele_name
    Where 1=1
        -- And na.hla_g_group<>a.hla_g_group 
    Order By a.allele_name
