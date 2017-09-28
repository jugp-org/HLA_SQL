use DNA_FASTQ
Go
-- ==================================================
-- paley 01.09.2017
-- Инициализация данных fastQ
-- ==================================================
-- Пример выполнения
-- ==================================================
-- create Procedure [dbo].[fastQ_Data_Init] as Begin declare @i int; end
-- Grant execute on [fastQ_Data_Init] to public
-- ==================================================
Alter Procedure [dbo].[fastQ_Data_Init]
As
Begin

    Print '=================================================='
    Print '*** [fastQ_Data_Init]'


    Declare @n_beg  Int
            ,@n_end Int
            ,@n     Int
            ,@max_n Int

    Select @n_beg=20
    Select @n_end=40

    -- ==================================================
    -- Цикл по данным, запись в файл хороших данных :) hls_wreads
    -- ==================================================
    If 1=1
    begin
        Truncate Table hla_wreads
	    Insert [hla_wreads] (
	         [read_sid]
	        ,[read_seq]
	        ,[read_seq_e]
            ,[read_qual]
            ,[k_forward_back]
            )
	        Select r.[read_sid]
                  ,r.[read_data]
                  ,r.[read_data]
                  ,r.read_quality
                  ,1
                From [hla_reads] r
	            Where len(r.read_data)>140

        --Update [hla_wreads]
        --    Set read_id=Cast(Replace(Replace(read_sid,'@CXZDV',''),':','') As Bigint)
        Update [hla_wreads]
            Set read_id=Cast(Replace( Substring(read_sid,8,Len(read_sid)-7) ,':','') As Bigint)

    End

    -- ==================================================
    -- Добавить обратные половинки
    -- ==================================================
    If 1=0
    begin
        Print '=================================================='
        Print '*** Добавить комплиментарные половинки'
	    Insert [hla_wreads] (
	         [read_id]
	        ,[read_sid]
	        ,[read_seq]
	        ,[read_seq_e]
            ,[read_qual]
            ,[k_forward_back]
            )
	        Select
                 r.read_id
                ,r.[read_sid]
                ,r.[read_seq]
                ,r.[read_seq_e]
                ,r.[read_qual]
                ,2
            From [hla_wreads] r
            Where r.k_forward_back=1

	    -- Перевернули
        Update [hla_wreads]
            Set [read_seq_e]	= REVERSE([read_seq_e])
            Where k_forward_back = 2

	    -- Заменили на комплиментарную
        -- A->1->T
        -- T->2->A
        -- C->3->G
        -- G->4->C
        Update [hla_wreads]
            Set [read_seq_e]	= Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace([read_seq_e],'A','1'),'T','2'),'C','3'),'G','4'),'1','T'),'2','A'),'3','G'),'4','C')
            Where k_forward_back = 2

	    ---- **************************************************
	    ---- 
	    ---- **************************************************
	    --Insert [hla_wreads] (
	    --     [read_id]
	    --    ,[read_sid]
	    --    ,[read_seq]
	    --    ,[read_seq_e]
     --       ,[read_qual]
     --       ,[k_forward_back]
     --       )
	    --    Select
     --            r.read_id
     --           ,r.[read_sid]
     --           ,r.[read_seq]
     --           ,r.[read_seq_e]
     --           ,r.[read_qual]
     --           ,3
     --       From [hla_wreads] r
     --       Where r.k_forward_back=1

	    ---- Перевернули
     --   Update [hla_wreads]
     --       Set [read_seq_e]	= REVERSE([read_seq_e])
     --       Where k_forward_back = 3

	    ---- **************************************************
	    ---- 
	    ---- **************************************************
	    --Insert [hla_wreads] (
	    --     [read_id]
	    --    ,[read_sid]
	    --    ,[read_seq]
	    --    ,[read_seq_e]
     --       ,[read_qual]
     --       ,[k_forward_back]
     --       )
	    --    Select
     --            r.read_id
     --           ,r.[read_sid]
     --           ,r.[read_seq]
     --           ,r.[read_seq_e]
     --           ,r.[read_qual]
     --           ,4
     --       From [hla_wreads] r
     --       Where r.k_forward_back=1

	    ---- Заменили на комплиментарную
     --   -- A->1->T
     --   -- T->2->A
     --   -- C->3->G
     --   -- G->4->C
     --   Update [hla_wreads]
     --       Set [read_seq_e]	= Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace([read_seq_e],'A','1'),'T','2'),'C','3'),'G','4'),'1','T'),'2','A'),'3','G'),'4','C')
     --       Where k_forward_back = 4

    End


    -- ==================================================
    -- Удалим все начальные и конечные до плохого качества
    -- !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHI
    -- select ascii('5')
    -- ==================================================
    if 1=0
    Begin
        Print '=================================================='
        Print '*** Инициализация beg-end'

        -- Начальные плохие чтения
        Select @n=1
        While @n<=@n_beg
        Begin
            Print 'beg step='+Cast(@n As varchar(20))
            Update hla_wreads
                Set read_seq_e = Stuff(read_seq_e,@n,1,'_')
                Where Substring(read_qual,@n,1) In ('!','"','#','$','%','&','''','(',')','*','+',',','-','.','/','0','1','2','3','4','5')
            Select  @n=@n+1
        End

        -- Конечные плохие чтения
        Select @n=1
        While @n<=@n_end
        Begin
            Print 'end step='+Cast(@n As varchar(20))
            Update hla_wreads
                Set read_seq_e = Stuff(read_seq_e,len(read_seq_e)-@n+1,1,'_')
                Where Substring(read_qual,len(read_qual)-@n+1,1) In ('!','"','#','$','%','&','''','(',')','*','+',',','-','.','/','0','1','2','3','4','5')
            Select  @n=@n+1
        End

        -- Удалим их
        Select @n=1
        While @n<=@n_beg
        Begin
            Print 'del beg step='+Cast(@n As varchar(20))
            Update hla_wreads
                Set read_seq_e = Substring(read_seq_e,Charindex('_',read_seq_e)+1,1000)
                    ,read_qual = Substring(read_qual,Charindex('_',read_seq_e)+1,1000)
                Where Charindex('_',read_seq_e)<@n_beg+1
            Select  @n=@n+1
        End

        Update hla_wreads
            Set read_seq_e = Substring(read_seq_e,1,Charindex('_',read_seq_e)-1)
                ,read_qual = Substring(read_qual,1,Charindex('_',read_seq_e)-1)
        Where Charindex('_',read_seq_e)>0

        Delete
            from hla_wreads
            Where Len(read_seq_e)<110

        Select * From hla_wreads
    End


    -- ==================================================
    -- Инициализация строки данных 0123
    -- ==================================================
    If 1=1
    Begin
        Print '=================================================='
        Print '*** Инициализация 0123'
        Select @max_n=Max(len(hw.read_seq_e))
            From hla_wreads hw

        Update hla_wreads
            Set read_seq_x=''

        Select @n=1
        While @n<=@max_n
        Begin
            Print 'x-num step='+Cast(@n As varchar(20))
            Update hla_wreads
                Set read_seq_x=read_seq_x+case Substring(read_seq_e,@n,1) When 'A' Then '0' When 'C' Then '1' When 'G' Then '2' When 'T' Then '3' End
                Where Len(read_seq_e)>=@n
            Select @n=@n+1
        End

        Update hla_wreads
            Set read_len_x = len(read_seq_x)

    End

    -- ==================================================
    -- Проставим плохие чтения
    -- !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHI
    -- select ascii('5')
    -- ==================================================
    If 1=0
    Begin
        if object_id('tempdb..#t_tmp') Is Not null
            Drop table #t_tmp

        Select @max_n=Max(len(hw.read_seq_e))
            From hla_wreads hw

        Select hw.*
            Into #t_tmp
            From hla_wreads hw With (Nolock)

        Select @n=1
        While @n<=@max_n
        Begin
            Print 'bad step='+Cast(@n As varchar(20))
            Update #t_tmp
                Set read_seq_e = Stuff(read_seq_e,@n,1,'_')
                Where Len(read_seq_e)>=@n
                    and Substring(read_qual,@n,1) In ('!','"','#','$','%','&','''','(',')','*','+',',','-','.','/','0','1','2','3','4','5')
            Select  @n=@n+1
        End

        Select Len(read_seq_e)-Len(Replace(read_seq_e,'_','')),*
            From #t_tmp
            Where 1=1
                and Len(read_seq_e)-Len(Replace(read_seq_e,'_',''))<=15
                and charindex('__',read_seq_e)=0
            Order By read_seq_e

        Select Len(read_seq_e)-Len(Replace(read_seq_e,'_','')),*
            From #t_tmp
            Where 1=1
                and Len(read_seq_e)-Len(Replace(read_seq_e,'_',''))=0
            Order By read_seq_e

        -- ==================================================
        -- А поищем ка по точному совпадению :)
        -- ==================================================
        Select e.*
            From #t_tmp t
                ,hla_uexon e With (Nolock)
            Where 1=1
                and Len(read_seq_e)-Len(Replace(read_seq_e,'_',''))=0
                and charindex(rtrim(e.uexon_seq),t.read_seq_e)>0
            Order By e.uexon_id

    End

End
