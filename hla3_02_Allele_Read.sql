-- ==================================================
-- paley 07.12.2017
-- Прочитать файл Allelelist.txt
-- ==================================================
-- Пример выполнения
-- ==================================================
-- create Procedure [dbo].[hla3_Allele_Read] as Begin declare @i int; end
-- Grant execute on [hla3_Allele_Read] to public
-- ==================================================
Alter Procedure [dbo].hla3_Allele_Read
    @file_name      Varchar(Max)    = null
    ,@fmt_name      Varchar(Max)    = null
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
        Drop table #allele_load

    Create table #allele_load (
          data_str          Varchar(max)
	    ,[allele_id]        varchar(30) Null
	    ,[allele_name]		varchar(50)
    )

	-- ==================================================
	-- Прочитать из файла
	-- ==================================================
    print '**************************************************'
    print 'Чтение данных из файла:'+@file_name
    print '**************************************************'
    Select @cSql = 'bulk insert #allele_load from '''+@file_name+''' With (DATAFILETYPE = ''char'' ,FORMATFILE = '''+@fmt_name+''')  ';
    -- Select @cSql
    exec sp_executesql @cSql;

    Delete 
        From #allele_load
        Where isNull(data_str,'')=''

    Update #allele_load
        Set  [allele_id]    = Substring(data_str,1,Charindex(' ',data_str)-1)
            ,[allele_name]  = Substring(data_str,Charindex(' ',data_str)+1,Len(data_str))

    -- ==================================================
    -- Обновить данные в таблице аллелей
    -- ==================================================
    Update hla3_alleles
        Set allele_id = t.allele_id
        From hla3_alleles a
            Inner Join #allele_load t On 'HLA-'+t.allele_name=a.allele_name

    --Select * From #allele_load
    --Select * From hla3_alleles

            
End