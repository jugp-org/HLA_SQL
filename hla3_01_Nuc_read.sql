-- ==================================================
-- paley 07.12.2017
-- Прочитать .nuc файл
-- ==================================================
-- Пример выполнения
-- Exec [hla3_Nuc_Read] @file_name=N'C:\WORK\PROJECT\HLA_PROJ\NGS_DATA\ftp_data\A_nuc.txt', @exon_cnt=3
-- Exec [hla3_Nuc_Read] @file_name=N'C:\WORK\PROJECT\HLA_PROJ\NGS_DATA\ftp_data\B_nuc.txt', @exon_cnt=3
-- Exec [hla3_Nuc_Read] @file_name=N'C:\WORK\PROJECT\HLA_PROJ\NGS_DATA\ftp_data\C_nuc.txt', @exon_cnt=3
-- Exec [hla3_Nuc_Read] @file_name=N'C:\WORK\PROJECT\HLA_PROJ\NGS_DATA\ftp_data\DPB1_nuc.txt', @exon_cnt=2
-- Exec [hla3_Nuc_Read] @file_name=N'C:\WORK\PROJECT\HLA_PROJ\NGS_DATA\ftp_data\DQB1_nuc.txt', @exon_cnt=2
-- Exec [hla3_Nuc_Read] @file_name=N'C:\WORK\PROJECT\HLA_PROJ\NGS_DATA\ftp_data\DRB_nuc.txt',  @exon_cnt=2
-- ==================================================
-- create Procedure [dbo].[hla3_Nuc_Read] as Begin declare @i int; end
-- Grant execute on [hla3_Nuc_Read] to public
-- ==================================================
Alter Procedure [dbo].[hla3_Nuc_Read]
    @file_name  Varchar(Max)    = null
    ,@fmt_name  Varchar(Max)    = null
    ,@exon_cnt  Int             = 3
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
    if object_id('tempdb..#nuc_load') is not null
        Drop table #nuc_load

    if object_id('tempdb..#nuc_seq') is not null
        Drop table #nuc_seq

    if object_id('tempdb..#nuc_exon') is not null
        Drop table #nuc_exon

    Create table #nuc_load (
        nuc_str         Varchar(max)
        ,row_num        Numeric(14) Identity
        ,allele_name    varchar(50) Null
        ,allele_part    varchar(max)
    )

    Create table #nuc_seq (
        allele_name     Varchar(50)
        ,allele_seq     Varchar(Max)
        ,row_num        Numeric(14) 
    )

    Create table #nuc_exon (
        allele_name     Varchar(50)
        ,exon_num       Int
        ,exon_seq       Varchar(max)
    )
    Create Index _tmp_nuc_exon1 On #nuc_exon(allele_name,exon_num)        


	-- ==================================================
	-- Прочитать из файла
	-- ==================================================
    print '**************************************************'
    print 'Чтение данных из файла:'+@file_name
    print '**************************************************'
    Select @cSql = 'bulk insert #nuc_load from '''+@file_name+''' With (DATAFILETYPE = ''char'' ,FORMATFILE = '''+@fmt_name+''')  ';
    -- Select @cSql
    exec sp_executesql @cSql;

    --bulk insert #nuc_load
    --      from @file_name
    --      With (DATAFILETYPE = 'char'
    --            ,FORMATFILE = 'C:\WORK\PROJECT\HLA_PROJ\NGS_DATA\ftp_data\_nuc.fmt')

    -- Select * From #nuc_load

    -- ==================================================
    -- Сформировать таблицу аллелей
    -- ==================================================
    Declare @n1 Numeric(14)
    Select @n1=Min(Case 
                        When Charindex('|',nuc_str)>0 Then Charindex('|',nuc_str)
                        Else 99999
                    End)-1
        From #nuc_load     

    Update #nuc_load     
        Set allele_name     = 'HLA-'+lTrim(rTrim(Substring(nuc_str,1,@n1)))
            ,allele_part    = lTrim(rTrim(Substring(nuc_str,@n1,1000)))
        Where Charindex('*',Substring(nuc_str,1,@n1))>0
    Create Index _tmp_nuc_load On #nuc_load(allele_name,row_num)        

    Truncate Table #nuc_seq
    Insert #nuc_seq (
            allele_name
        )
    Select Distinct allele_name
        From #nuc_load
        Where Isnull(Allele_Name,'')<>''
    Create Index _tmp_nuc_seq On #nuc_seq(allele_name)        

    -- Основная таблица аллелей
    Insert Into hla3_alleles (allele_name)
        Select allele_name
        From #nuc_seq
    Update hla3_alleles
        Set allele_id = Cast(allele_iid As Varchar(50))

    -- ==================================================
    -- Цикл по кускам аллелей
    -- ==================================================
    Declare @n_beg Int
    Declare @n_end Int

    Update #nuc_seq 
        Set allele_seq = ''

    Select @n_beg=Min(row_num)
        From #nuc_load nl
        Where lTrim(rTrim(nl.nuc_str))='|'
    Select @n_end=Min(row_num)
        From #nuc_load nl
        Where lTrim(rTrim(nl.nuc_str))='|'
            And row_num>@n_beg

    -- Проставить номера строк аллелей
    Update #nuc_seq 
        Set row_num = nl.row_num
        From #nuc_seq ns
            Inner Join #nuc_load nl On ns.allele_name=nl.allele_name
        Where nl.row_num>@n_beg
            And nl.row_num<isNull(@n_end,99999)

    While isNull(@n_beg,0)>0
    Begin
        Select @n_end=Min(row_num)
            From #nuc_load nl
            Where lTrim(rTrim(nl.nuc_str))='|'
                And row_num>@n_beg
        -- Print '@n_beg='+Cast(@n_beg As Varchar(10))
        If isNull(@n_end,0)>0 
        Begin
            Update #nuc_seq 
                Set allele_seq = allele_seq+nl.allele_part
                From #nuc_seq ns
                    Inner Join #nuc_load nl On ns.allele_name=nl.allele_name
                Where nl.row_num>@n_beg
                    And nl.row_num<@n_end
            Select @n_beg=@n_end
        End Else
        Begin
            Update #nuc_seq 
                Set allele_seq = allele_seq+nl.allele_part
                From #nuc_seq ns
                    Inner Join #nuc_load nl On ns.allele_name=nl.allele_name
                Where nl.row_num>@n_beg
            break
        End
    End

    Update #nuc_seq
        Set allele_seq=Replace(allele_seq,' ','')

    --Select  LEFT(cast(row_num As Varchar(10))+'               ',10)
    --        ,LEFT(nq.allele_name+'                    ',20)
    --        ,nq.allele_seq
    --    From #nuc_seq nq
    --    Order By nq.row_num


    -- ==================================================
    -- Восстановление последовательностей
    -- ==================================================
    Declare @min_row    Numeric(14)
    Declare @epos_beg   Numeric(14)
    Declare @epos_end   Numeric(14)
    Declare @min_seq    Varchar(Max)
    Declare @e2_seq     Varchar(Max)
    Declare @e3_seq     Varchar(Max)
    Declare @e4_seq     Varchar(Max)
    Declare @n2         Int
    Declare @es         Varchar(1)

    Select @min_row=Min(row_num)
        From #nuc_seq

    Select @min_seq=ns.allele_seq
        From #nuc_seq ns
        Where row_num=@min_row

    Truncate table #nuc_exon

    -- 2 экзон
    Select @epos_beg=Charindex('|',@min_seq)
    Select @epos_end=Charindex('|',@min_seq,@epos_beg+1)
    If @epos_end>0 
    Begin
        Select @e2_seq  = Substring(@min_seq ,@epos_beg+1,@epos_end-@epos_beg-1)
        Insert #nuc_exon
            (allele_name
            ,exon_num
            ,exon_seq)
            Select 
                    ns.allele_name
                    ,2
                    ,Substring(ns.allele_seq,@epos_beg+1,@epos_end-@epos_beg-1)
                From #nuc_seq ns
    End Else
    Begin
        Select @epos_end=99999    
    End

    -- 3 экзон
    Select @epos_beg=@epos_end
    Select @epos_end=Charindex('|',@min_seq,@epos_beg+1)
    If @epos_end>0 
    Begin
        Select @e3_seq  = Substring(@min_seq ,@epos_beg+1,@epos_end-@epos_beg-1)
        Insert #nuc_exon
            (allele_name
            ,exon_num
            ,exon_seq)
            Select 
                    ns.allele_name
                    ,3
                    ,Substring(ns.allele_seq,@epos_beg+1,@epos_end-@epos_beg-1)
                From #nuc_seq ns
    End Else 
    Begin
        Select @epos_end=99999    
    End

    -- 4 экзон
    If @exon_cnt>2
    Begin
        Select @epos_beg=@epos_end
        Select @epos_end=Charindex('|',@min_seq,@epos_beg+1)
        If @epos_end>0
        Begin
            Select @e4_seq  = Substring(@min_seq ,@epos_beg+1,@epos_end-@epos_beg-1)
            Insert #nuc_exon
                (allele_name
                ,exon_num
                ,exon_seq)
                Select 
                        ns.allele_name
                        ,4
                        ,Substring(ns.allele_seq,@epos_beg+1,@epos_end-@epos_beg-1)
                    From #nuc_seq ns
        End
    end

    -- 2 экзон Замена символов
    Select @n2=1
    While @n2<=Len(@e2_seq)
    Begin
	    Select @es=Substring(@e2_seq,@n2,1)
        Update #nuc_exon
            Set exon_seq = STUFF(exon_seq, @n2,1, Case when Substring(ne.exon_seq,@n2,1)='-' Then @es Else Substring(ne.exon_seq,@n2,1) End )
            From #nuc_exon ne
            Where ne.exon_num=2
        Select @n2=@n2+1
    End

    -- 3 экзон Замена символов
    Select @n2=1
    While @n2<=Len(@e3_seq)
    Begin
	    Select @es=Substring(@e3_seq,@n2,1)
        Update #nuc_exon
            Set exon_seq = STUFF(exon_seq, @n2,1, Case when Substring(ne.exon_seq,@n2,1)='-' Then @es Else Substring(ne.exon_seq,@n2,1) End )
            From #nuc_exon ne
            Where ne.exon_num=3
        Select @n2=@n2+1
    End

    -- 4 экзон Замена символов
    If @exon_cnt>2
    Begin
        Select @n2=1
        While @n2<=Len(@e4_seq)
        Begin
	        Select @es=Substring(@e4_seq,@n2,1)
            Update #nuc_exon
                Set exon_seq = STUFF(exon_seq, @n2,1, Case when Substring(ne.exon_seq,@n2,1)='-' Then @es Else Substring(ne.exon_seq,@n2,1) End )
                From #nuc_exon ne
                Where ne.exon_num=4
            Select @n2=@n2+1
        End
    End

    -- Заменить вставки
    Update #nuc_exon 
        Set exon_seq=Replace(exon_seq,'.','')

    --Select   LEFT(ne.allele_name+'                    ',20)
    --        ,LEFT(cast(exon_num As Varchar(10))+'               ',10)
    --        ,ne.exon_seq
    --    From #nuc_exon ne
    --    Order By ne.exon_num,ne.allele_name


    -- ==================================================
    -- Записать в основную таблицу экзонов
    -- ==================================================
    Insert Into hla3_features (
        [allele_id]
	    ,[feature_type]
	    ,[feature_name]
	    ,[feature_status]
	    ,[feature_nucsequence]
        )
    Select 
            a.allele_id
            ,'Exon'
            ,'Exon '+Cast(ne.exon_num As Varchar(1))
            ,'Complete'
            ,ne.exon_seq
        From #nuc_exon ne
        Inner Join hla3_alleles a With (Nolock) On a.allele_name=ne.allele_name

    Update hla3_features
        Set feature_id = Cast(feature_iid As Varchar(50))

    Update hla3_features
        Set [feature_status] = 'UnComplete'
        Where charindex('*',feature_nucsequence)>0


/*
    -- Проверка на HLA базу
    -- Список уникальных экзонов 
    -- в привязке к исходным данным
    Select f.allele_id
            ,a.allele_name
            ,f.feature_name
            ,ne.allele_name
            ,f.feature_nucsequence
        From dna2_hla.dbo.hla_features f With (Nolock)
            Inner Join dna2_hla.dbo.[hla_alleles] a With (Nolock) On a.allele_id=f.allele_id
            left Join #nuc_exon ne With (Nolock) 
                on ne.exon_seq=f.feature_nucsequence 
                And 'HLA-'+ne.allele_name=a.allele_name
                And f.feature_name = 'Exon '+Cast(ne.exon_num As Varchar(1))
        Where 1=1
                And a.allele_name Like 'HLA-A*%'
                And f.feature_name In ('Exon 2','Exon 3','Exon 4')
                And Isnull(ne.allele_name,'')=''
        Order By a.allele_name,f.feature_name,f.alignmentreference_alleleid 



    Select   LEFT(ne.allele_name+'                    ',20)
            ,LEFT(cast(exon_num As Varchar(10))+'               ',10)
            ,ne.exon_seq
        From #nuc_exon ne
        Where ne.allele_name='A*29:01:01:02N'
            And ne.exon_num=4
        Order By ne.exon_num,ne.allele_name
*/

End
