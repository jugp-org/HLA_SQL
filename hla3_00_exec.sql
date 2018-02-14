-- ==================================================
-- paley 07.12.2017
-- Загрузка данных
-- ==================================================
-- Пример выполнения
-- exec hla3_Data_Read @path_name='C:\WORK\PROJECT\HLA_PROJ\NGS_DATA\ftp_data'
-- ==================================================
-- Create Procedure [dbo].[hla3_Data_Read] as Begin declare @i int; end
-- Grant execute on [hla3_Data_Read] to public
-- ==================================================
Alter Procedure [dbo].hla3_Data_Read
    @path_name      Varchar(Max)    = ''
As
Begin

    -- ==================================================
    -- vars
    -- ==================================================
    Declare @file_name  Varchar(1024)    
    Declare @fmt_file   Varchar(250)

    -- ==================================================
    -- init path
    -- ==================================================
    Select @path_name='C:\WORK\PROJECT\HLA_PROJ\NGS_DATA\ftp_data'
    Select @path_name=lTrim(Rtrim(@path_name))
    If Substring(@path_name,Len(@path_name),1)<>'\' 
    Begin
	    Select @path_name=@path_name+'\'
    End

    -- ==================================================
    -- Загрузка .nuc файлов
    -- ==================================================
    Truncate Table [hla3_alleles]
    Truncate Table [hla3_features]

    -- ==================================================
    -- ftp://ftp.ebi.ac.uk/pub/databases/ipd/imgt/hla/Alignments_Rel_3310.zip
    -- или
    -- ftp://ftp.ebi.ac.uk/pub/databases/ipd/imgt/hla/alignments/
    -- ==================================================
    Select @fmt_file    = @path_name+'_nuc.fmt'

    Select @file_name   = @path_name+'A_nuc.txt'
    Exec [hla3_Nuc_Read] @file_name=@file_name, @fmt_name=@fmt_file, @exon_cnt=3
    
    Select @file_name   = @path_name+'B_nuc.txt'
    Exec [hla3_Nuc_Read] @file_name=@file_name, @fmt_name=@fmt_file, @exon_cnt=3

    Select @file_name   = @path_name+'C_nuc.txt'
    Exec [hla3_Nuc_Read] @file_name=@file_name, @fmt_name=@fmt_file, @exon_cnt=3

    Select @file_name   = @path_name+'DPB1_nuc.txt'
    Exec [hla3_Nuc_Read] @file_name=@file_name, @fmt_name=@fmt_file, @exon_cnt=2

    Select @file_name   = @path_name+'DQB1_nuc.txt'
    Exec [hla3_Nuc_Read] @file_name=@file_name, @fmt_name=@fmt_file, @exon_cnt=2

    Select @file_name   = @path_name+'DRB_nuc.txt'
    Exec [hla3_Nuc_Read] @file_name=@file_name,  @fmt_name=@fmt_file, @exon_cnt=2

    Select @file_name   = @path_name+'DMA_nuc.txt'
    Exec [hla3_Nuc_Read] @file_name=@file_name,  @fmt_name=@fmt_file, @exon_cnt=2

    Select @file_name   = @path_name+'DMB_nuc.txt'
    Exec [hla3_Nuc_Read] @file_name=@file_name,  @fmt_name=@fmt_file, @exon_cnt=2

    Select @file_name   = @path_name+'DOA_nuc.txt'
    Exec [hla3_Nuc_Read] @file_name=@file_name,  @fmt_name=@fmt_file, @exon_cnt=2

    Select @file_name   = @path_name+'DOB_nuc.txt'
    Exec [hla3_Nuc_Read] @file_name=@file_name,  @fmt_name=@fmt_file, @exon_cnt=2

    Select @file_name   = @path_name+'DPA1_nuc.txt'
    Exec [hla3_Nuc_Read] @file_name=@file_name, @fmt_name=@fmt_file, @exon_cnt=2

    Select @file_name   = @path_name+'DPA2_nuc.txt'
    Exec [hla3_Nuc_Read] @file_name=@file_name, @fmt_name=@fmt_file, @exon_cnt=2

    Select @file_name   = @path_name+'DPB2_nuc.txt'
    Exec [hla3_Nuc_Read] @file_name=@file_name, @fmt_name=@fmt_file, @exon_cnt=2

    Select @file_name   = @path_name+'DQA1_nuc.txt'
    Exec [hla3_Nuc_Read] @file_name=@file_name, @fmt_name=@fmt_file, @exon_cnt=2

    Select @file_name   = @path_name+'DRA_nuc.txt'
    Exec [hla3_Nuc_Read] @file_name=@file_name,  @fmt_name=@fmt_file, @exon_cnt=2

    Select @file_name   = @path_name+'E_nuc.txt'
    Exec [hla3_Nuc_Read] @file_name=@file_name, @fmt_name=@fmt_file, @exon_cnt=3

    Select @file_name   = @path_name+'F_nuc.txt'
    Exec [hla3_Nuc_Read] @file_name=@file_name, @fmt_name=@fmt_file, @exon_cnt=3

    Select @file_name   = @path_name+'G_nuc.txt'
    Exec [hla3_Nuc_Read] @file_name=@file_name, @fmt_name=@fmt_file, @exon_cnt=3

    Select @file_name   = @path_name+'H_nuc.txt'
    Exec [hla3_Nuc_Read] @file_name=@file_name, @fmt_name=@fmt_file, @exon_cnt=3

    Select @file_name   = @path_name+'HFE_nuc.txt'
    Exec [hla3_Nuc_Read] @file_name=@file_name, @fmt_name=@fmt_file, @exon_cnt=2

    Select @file_name   = @path_name+'J_nuc.txt'
    Exec [hla3_Nuc_Read] @file_name=@file_name, @fmt_name=@fmt_file, @exon_cnt=3

    Select @file_name   = @path_name+'K_nuc.txt'
    Exec [hla3_Nuc_Read] @file_name=@file_name, @fmt_name=@fmt_file, @exon_cnt=3

    Select @file_name   = @path_name+'L_nuc.txt'
    Exec [hla3_Nuc_Read] @file_name=@file_name, @fmt_name=@fmt_file, @exon_cnt=3

    Select @file_name   = @path_name+'MICA_nuc.txt'
    Exec [hla3_Nuc_Read] @file_name=@file_name, @fmt_name=@fmt_file, @exon_cnt=2

    Select @file_name   = @path_name+'MICB_nuc.txt'
    Exec [hla3_Nuc_Read] @file_name=@file_name, @fmt_name=@fmt_file, @exon_cnt=2

    Select @file_name   = @path_name+'T_nuc.txt'
    Exec [hla3_Nuc_Read] @file_name=@file_name, @fmt_name=@fmt_file, @exon_cnt=3

    Select @file_name   = @path_name+'TAP1_nuc.txt'
    Exec [hla3_Nuc_Read] @file_name=@file_name, @fmt_name=@fmt_file, @exon_cnt=2

    Select @file_name   = @path_name+'TAP2_nuc.txt'
    Exec [hla3_Nuc_Read] @file_name=@file_name, @fmt_name=@fmt_file, @exon_cnt=2

    Select @file_name   = @path_name+'V_nuc.txt'
    Exec [hla3_Nuc_Read] @file_name=@file_name, @fmt_name=@fmt_file, @exon_cnt=3

    Select @file_name   = @path_name+'W_nuc.txt'
    Exec [hla3_Nuc_Read] @file_name=@file_name, @fmt_name=@fmt_file, @exon_cnt=3

    Select @file_name   = @path_name+'Y_nuc.txt'
    Exec [hla3_Nuc_Read] @file_name=@file_name, @fmt_name=@fmt_file, @exon_cnt=3


    -- ==================================================
    -- Загрузка ид. аллелей
    -- ftp://ftp.ebi.ac.uk/pub/databases/ipd/imgt/hla/Allelelist.txt
    -- ==================================================
    Select @fmt_file    = @path_name+'_allele.fmt'
    Select @file_name   = @path_name+'Allelelist.txt'
    exec hla3_Allele_Read
         @file_name = @file_name
        ,@fmt_name  = @fmt_file

    -- ==================================================
    -- Загрузка групп аллелей
    -- Здесь же читается номер и дата версии данных IPD-IMGT/HLA
    -- ftp://ftp.ebi.ac.uk/pub/databases/ipd/imgt/hla/wmda/
    -- ==================================================
    Select @fmt_file    = @path_name+'_group.fmt'

    Select @file_name   = @path_name+'hla_nom_g.txt'
    exec hla3_Group_Read
        @file_name  = @file_name
        ,@fmt_name  = @fmt_file
        ,@file_type = 'G'

    Select @file_name   = @path_name+'hla_nom_p.txt'
    exec hla3_Group_Read
        @file_name  = @file_name
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

End
