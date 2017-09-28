use DNA_FASTQ
Go
-- ==================================================
-- paley 01.09.2017
-- Создать HASH для reads
-- ==================================================
-- Пример выполнения
-- ==================================================
-- create Procedure [dbo].[fastQ_Hash_create] as Begin declare @i int; end
-- Grant execute on [fastQ_Data_Init] to public
-- ==================================================
Alter Procedure [dbo].[fastQ_Hash_create]
As
Begin

    Print '=================================================='
    Print '*** [fastQ_Hash_create]'

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

    -- **************************************************
    -- Создать Hash по Reads
    -- **************************************************
    If 1=1
    Begin
        Select @max_n=Max(len(hr.read_seq_x))
            From hla_wreads hr
        Truncate Table hla_reads_part

        -- ==================================================
        -- Цикл по данным
        -- Куски равной длины
        -- ==================================================
        --Select @n=1
        --While @n<@max_n-@hash_len
        --Begin
        --    Print 'reads-part Step='+Cast(@n As varchar(20))
        --	Insert hla_reads_part
        --        (read_id,rpart_pos,rpart_seq)
        --    Select hr.read_id, @n, Substring(hr.read_data,@n,@hash_len)
        --        From hla_reads hr
        --        Where Len(hr.read_data)>=@n+@hash_len-1
        --            And Len(hr.read_data)>=120
        --    Select @n=@n+@hash_len
        --End

        -- ==================================================
        -- Цикл по данным
        -- Старт с каждого символа
        -- ==================================================
        Select @n=1
        While @n<=@max_n-@hash_len+1
        Begin
            Print 'read-part step='+Cast(@n As varchar(20))
    	    Insert hla_reads_part
                 (read_id,read_iid,rpart_pos,rpart_seq_x)
            Select hr.read_id, hr.read_iid, @n, Substring(hr.read_seq_x,@n,@hash_len)
                From hla_wreads hr
                Where Len(hr.read_seq_x)>=@n+@hash_len-1
--                    And Len(hr.read_data)>=120
            Select @n=@n+1
        End

        Update hla_reads_part
            Set [rpart_id]=cast(Substring(rpart_seq_x,1,1)
                        +Substring(rpart_seq_x,2,1)*4
                        +Substring(rpart_seq_x,3,1)*16
                        +Substring(rpart_seq_x,4,1)*64
                        +Substring(rpart_seq_x,5,1)*256
                        +Substring(rpart_seq_x,6,1)*1024
                        +Substring(rpart_seq_x,7,1)*4096
                        +Substring(rpart_seq_x,8,1)*16384
                        +Substring(rpart_seq_x,9,1)*65536
                        +Substring(rpart_seq_x,10,1)*262144
                        +Substring(rpart_seq_x,11,1)*1048576
                        +Substring(rpart_seq_x,12,1)*4194304
                        --+Substring(rpart_seq_x,13,1)*16777216
                        --+Substring(rpart_seq_x,14,1)*67108864
                        --+cast(Substring(rpart_seq_x,15,1) As Bigint)*268435456
                        --+cast(Substring(rpart_seq_x,16,1) As Bigint)*1073741824
                        --+cast(Substring(rpart_seq_x,17,1) As Bigint)*4294967296
                        --+cast(Substring(rpart_seq_x,18,1) As Bigint)*17179869184
                        As Bigint)

        -- Уникальные
        Truncate Table hla_reads_upart
        Insert Into hla_reads_upart
            (urpart_seq_x, urpart_cnt, rpart_id)
            Select p.rpart_seq_x, Count(*), p.rpart_id
                From hla_reads_part p
                Group By p.rpart_id, p.rpart_seq_x


    End

End