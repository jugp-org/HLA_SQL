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
                Inner Join dna2_hla.dbo.hla_uexon_upart ep With (Nolock Index=[hla_uexon_upart_idx2]) On ep.epart_seq=Substring(rd.read_seq,@n ,@hash_len)
    	        Where Len(rd.read_seq)>= @n+@hash_len-1
            Select @n=@n+1
        End

    End

    -- **************************************************
    -- Создать униальные reads part
    -- **************************************************
    Truncate Table hla_reads_upart
    Insert Into hla_reads_upart
      (
        urpart_cnt
       ,rpart_hash
       ,k_ex
      )
    Select Count(*)
          ,p.rpart_hash
          ,0
        From hla_reads_part p
        Group By p.rpart_hash

    Update hla_reads_upart
        Set k_ex=1
        From hla_reads_upart up
        Where up.rpart_hash In (Select up.epart_hash
                                  From dna2_hla.dbo.hla_uexon_part up)

    Delete 
        from hla_reads_upart
        Where k_ex=0

    --Delete 
    --    from hla_reads_part
    --    where rpart_hash Not In (Select rpart_hash From hla_reads_upart)


End