-- ==================================================
-- paley 01.09.2017
-- Создать HASH для reads
-- ==================================================
-- Пример выполнения
-- ==================================================
-- create Procedure [dbo].[hla_Hash_create] as Begin declare @i int; end
-- Grant execute on [fastQ_Data_Init] to public
-- ==================================================
Alter Procedure [dbo].[hla_Hash_create]
As
Begin

    Print '=================================================='
    Print '*** [hla_Hash_create]'

    -- ==================================================
    --
    -- ==================================================
    Declare @n          Int
           ,@max_n      Int
           ,@hash_Len   Int

    -- ==================================================
    -- init
    -- ==================================================
    Select @hash_len = 12

    Update hla_uexon
        Set epart_cnt   = [uexon_len_x]/@hash_len

    -- **************************************************
    -- Создать Hash по Экзонам последовательно по @hash_len
    -- **************************************************
    If 1=1
    Begin
        Select @max_n=Max(len(ue.uexon_seq))
            From hla_uexon ue
        Truncate Table hla_uexon_part

        -- ==================================================
        -- Цикл по данным
        -- Куски равной длины
        -- ==================================================
        Select @n=1
        While @n<@max_n-@hash_len
        Begin
            Print 'exon-part Step='+Cast(@n As varchar(20))
    	    Insert hla_uexon_part
                 (uexon_iid,epart_pos,epart_seq_x)
            Select ue.uexon_iid, @n, Substring(ue.uexon_seq_x,@n,@hash_len)
                From hla_uexon ue
                Where Len(ue.uexon_seq_x)>=@n+@hash_len-1
            Select @n=@n+@hash_len
        End

        Update hla_uexon_part
            Set epart_id = cast(Substring(epart_seq_x,1,1)
                        +Substring(epart_seq_x,2,1)*4
                        +Substring(epart_seq_x,3,1)*16
                        +Substring(epart_seq_x,4,1)*64
                        +Substring(epart_seq_x,5,1)*256
                        +Substring(epart_seq_x,6,1)*1024
                        +Substring(epart_seq_x,7,1)*4096
                        +Substring(epart_seq_x,8,1)*16384
                        +Substring(epart_seq_x,9,1)*65536
                        +Substring(epart_seq_x,10,1)*262144
                        +Substring(epart_seq_x,11,1)*1048576
                        +Substring(epart_seq_x,12,1)*4194304
                        --+Substring(epart_seq_x,13,1)*16777216
                        --+Substring(epart_seq_x,14,1)*67108864
                        --+cast(Substring(epart_seq_x,15,1) As Bigint)*268435456
                        --+cast(Substring(epart_seq_x,16,1) As Bigint)*1073741824
                        --+cast(Substring(epart_seq_x,17,1) As Bigint)*4294967296
                        --+cast(Substring(epart_seq_x,18,1) As Bigint)*17179869184
                        As Bigint)

        ---- Уникальные
        --Truncate Table hla_reads_upart
        --Insert Into hla_reads_upart
        --    (uepart_seq_x, urpart_cnt, rpart_id)
        --    Select p.epart_seq_x, Count(*), p.rpart_id
        --        From hla_reads_part p
        --        Group By p.rpart_id, p.epart_seq_x


    End


    -- **************************************************
    -- Создать Hash по Экзонам c каждой позиции
    -- **************************************************
    If 1=1
    Begin
        Select @max_n=Max(len(ue.uexon_seq))
            From hla_uexon ue
        Truncate Table hla_uexon_part2

        -- ==================================================
        -- Цикл по данным
        -- Старт с каждого символа
        -- ==================================================
        Select @n=1
        While @n<=@max_n-@hash_len+1
        Begin
            Print 'exon-part step='+Cast(@n As varchar(20))
    	    Insert hla_uexon_part2
                 (uexon_iid,epart_pos,epart_seq_x)
            Select ue.uexon_iid, @n, Substring(ue.uexon_seq_x,@n,@hash_len)
                From hla_uexon ue
                Where Len(ue.uexon_seq_x)>=@n+@hash_len-1
            Select @n=@n+1
        End

        Update hla_uexon_part2
            Set epart_id = cast(Substring(epart_seq_x,1,1)
                        +Substring(epart_seq_x,2,1)*4
                        +Substring(epart_seq_x,3,1)*16
                        +Substring(epart_seq_x,4,1)*64
                        +Substring(epart_seq_x,5,1)*256
                        +Substring(epart_seq_x,6,1)*1024
                        +Substring(epart_seq_x,7,1)*4096
                        +Substring(epart_seq_x,8,1)*16384
                        +Substring(epart_seq_x,9,1)*65536
                        +Substring(epart_seq_x,10,1)*262144
                        +Substring(epart_seq_x,11,1)*1048576
                        +Substring(epart_seq_x,12,1)*4194304
                        --+Substring(epart_seq_x,13,1)*16777216
                        --+Substring(epart_seq_x,14,1)*67108864
                        --+cast(Substring(epart_seq_x,15,1) As Bigint)*268435456
                        --+cast(Substring(epart_seq_x,16,1) As Bigint)*1073741824
                        --+cast(Substring(epart_seq_x,17,1) As Bigint)*4294967296
                        --+cast(Substring(epart_seq_x,18,1) As Bigint)*17179869184
                        As Bigint)

    End



End