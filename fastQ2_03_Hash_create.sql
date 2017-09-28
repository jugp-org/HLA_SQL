use DNA2_FASTQ
Go
-- ==================================================
-- paley 01.09.2017
-- Создать HASH для reads
-- ==================================================
-- Пример выполнения
-- ==================================================
-- create Procedure [dbo].[fastQ2_Hash_create] as Begin declare @i int; end
-- Grant execute on [fastQ2_Data_Init] to public
-- ==================================================
Alter Procedure [dbo].[fastQ2_Hash_create]
As
Begin

    Print '=================================================='
    Print '*** [fastQ2_Hash_create]'

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
        Select @max_n=Max(len(hr.read_seq))
            From hla_reads hr
        Truncate Table hla_reads_part

        -- ==================================================
        -- Цикл по данным
        -- Старт с каждого символа
        -- ==================================================
        Select @n=1
        While @n<=@max_n-@hash_len+1
        Begin
            Print 'read-part step='+Cast(@n As varchar(20))
    	    Insert hla_reads_part
    	      (
    	        read_iid
    	       ,rpart_pos
    	       ,rpart_hash
    	      )
    	    Select rd.read_iid
    	          , @n
    	          , dbo.sql_str_hash_get(Substring(rd.read_seq,@n ,@hash_len))
    	        From hla_reads rd
    	        Where Len(rd.read_seq)>= @n+@hash_len-1
            Select @n=@n+1
        End

    End

End