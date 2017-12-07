-- ==================================================
-- paley 07.12.2017
-- Прочитать файл hla_nom_p.txt или hla_nom_g.txt
-- ==================================================
-- Пример выполнения
-- ==================================================
-- create Procedure [dbo].[hla3_Group_Read] as Begin declare @i int; end
-- Grant execute on [hla3_Group_Read] to public
-- ==================================================
Alter Procedure [dbo].hla3_Group_Read
    @file_name      Varchar(Max)    = null
    ,@fmt_name      Varchar(Max)    = null
    ,@file_type     Varchar(Max)    = 'G'
As
Begin

    Set Nocount On;

    -- ==================================================
    -- 
    -- ==================================================
    Declare @cSql  NVarchar(1024)

    -- ==================================================
    -- 
    -- ==================================================
    if object_id('tempdb..#group_load') is not null
        Drop table #group_load

    Create table #group_load (
        data_str        Varchar(max)
        ,row_num        Numeric(14) Identity
        ,gen_cd         varchar(50) Null
        ,allele_str     varchar(max)
        ,gr_cd          varchar(max)
    )

	-- ==================================================
	-- Прочитать из файла
	-- ==================================================
    print '**************************************************'
    print 'Чтение данных из файла:'+@file_name
    print '**************************************************'
    Select @cSql = 'bulk insert #group_load from '''+@file_name+''' With (DATAFILETYPE = ''char'' ,FORMATFILE = '''+@fmt_name+''')  ';
    -- Select @cSql
    exec sp_executesql @cSql;

    Delete 
        From #group_load
        Where Charindex(';',data_str)=0

    Update #group_load
        Set gen_cd = Substring(data_str,1,Charindex(';',data_str)-1)

    Update #group_load
        Set data_str = Substring(data_str,Charindex(';',data_str)+1,99999)

    Update #group_load
        Set allele_str = Substring(data_str,1,Charindex(';',data_str)-1)

    Update #group_load
        Set data_str = Substring(data_str,Charindex(';',data_str+'         ')+1,99999)

    Update #group_load
        Set gr_cd = lTrim(rTrim(data_str))

    Update #group_load
        Set allele_str = 'HLA-'+gen_cd+Replace(allele_str,'/','/HLA-'+gen_cd)+'/'


    --Select *
    --    From #group_load

    -- ==================================================
    -- Обновить данные в таблице аллелей
    -- ==================================================
    If @file_type='G' 
    Begin
        Update hla3_alleles
            Set hla_g_group = 'None'

        Update hla3_alleles
            Set hla_g_group = t.gen_cd+t.gr_cd
            From hla3_alleles a
                Inner Join #group_load t On Charindex(a.allele_name+'/',t.allele_str)>0 And t.gr_cd<>''
            
    End

    If @file_type='P' 
    Begin
        Update hla3_alleles
            Set hla_p_group = 'None'

        Update hla3_alleles
            Set hla_p_group = t.gen_cd+t.gr_cd
            From hla3_alleles a
                Inner Join #group_load t On Charindex(a.allele_name+'/',t.allele_str)>0 And t.gr_cd<>''
            
    End


End
