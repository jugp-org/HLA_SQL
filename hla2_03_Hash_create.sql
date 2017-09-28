-- ==================================================
-- paley 01.09.2017
-- ������� HASH ��� reads
-- ==================================================
-- ������ ����������
-- ==================================================
-- create Procedure [dbo].[hla2_Hash_create] as Begin declare @i int; end
-- Grant execute on [hla2_Hash_create] to public
-- ==================================================
Alter Procedure [dbo].[hla2_Hash_create]
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
        Set epart_cnt   = [uexon_len]/@hash_len

    -- **************************************************
    -- ������� Hash �� ������� ��������������� �� @hash_len
    -- **************************************************
    If 1=1
    Begin
        Select @max_n=Max(len(ue.uexon_seq))
            From hla_uexon ue
        Truncate Table hla_uexon_part

        -- ==================================================
        -- ���� �� ������
        -- ����� ������ �����
        -- ==================================================
        Select @n=1
        While @n<@max_n-@hash_len
        Begin
            Print 'exon-part Step='+Cast(@n As varchar(20))
    	    Insert hla_uexon_part
    	      (
    	        uexon_iid
    	       ,epart_pos
               ,epart_hash
    	      )
    	    Select ue.uexon_iid
    	          , @n
    	          , dbo.sql_str_hash_get(Substring(ue.uexon_seq,@n ,@hash_len))

                      --        (Case Substring(ue.uexon_seq,@n ,1)  When 'A' Then 0 When 'C' Then 1 When 'G' Then 2 When 'T' Then 3 End)
                      --+       4*(Case Substring(ue.uexon_seq,@n ,2)  When 'A' Then 0 When 'C' Then 1 When 'G' Then 2 When 'T' Then 3 End)
                      --+      16*(Case Substring(ue.uexon_seq,@n ,3)  When 'A' Then 0 When 'C' Then 1 When 'G' Then 2 When 'T' Then 3 End)
                      --+      64*(Case Substring(ue.uexon_seq,@n ,4)  When 'A' Then 0 When 'C' Then 1 When 'G' Then 2 When 'T' Then 3 End)
                      --+     256*(Case Substring(ue.uexon_seq,@n ,5)  When 'A' Then 0 When 'C' Then 1 When 'G' Then 2 When 'T' Then 3 End)
                      --+    1024*(Case Substring(ue.uexon_seq,@n ,6)  When 'A' Then 0 When 'C' Then 1 When 'G' Then 2 When 'T' Then 3 End)
                      --+    4096*(Case Substring(ue.uexon_seq,@n ,7)  When 'A' Then 0 When 'C' Then 1 When 'G' Then 2 When 'T' Then 3 End)
                      --+   16384*(Case Substring(ue.uexon_seq,@n ,8)  When 'A' Then 0 When 'C' Then 1 When 'G' Then 2 When 'T' Then 3 End)
                      --+   65536*(Case Substring(ue.uexon_seq,@n ,9)  When 'A' Then 0 When 'C' Then 1 When 'G' Then 2 When 'T' Then 3 End)
                      --+  262144*(Case Substring(ue.uexon_seq,@n ,10) When 'A' Then 0 When 'C' Then 1 When 'G' Then 2 When 'T' Then 3 End)
                      --+ 1048576*(Case Substring(ue.uexon_seq,@n ,11) When 'A' Then 0 When 'C' Then 1 When 'G' Then 2 When 'T' Then 3 End)
                      --+ 4194304*(Case Substring(ue.uexon_seq,@n ,12) When 'A' Then 0 When 'C' Then 1 When 'G' Then 2 When 'T' Then 3 End)
                      --+      16777216*(Case Substring(ue.uexon_seq,@n ,13) When 'A' Then 0 When 'C' Then 1 When 'G' Then 2 When 'T' Then 3 End)
                      --+      67108864*(Case Substring(ue.uexon_seq,@n ,14) When 'A' Then 0 When 'C' Then 1 When 'G' Then 2 When 'T' Then 3 End)
                      --+      268435456*(Case Substring(ue.uexon_seq,@n ,15) When 'A' Then 0 When 'C' Then 1 When 'G' Then 2 When 'T' Then 3 End)
                      --+      1073741824*(Case Substring(ue.uexon_seq,@n ,16) When 'A' Then 0 When 'C' Then 1 When 'G' Then 2 When 'T' Then 3 End)
                      --+      4294967296*(Case Substring(ue.uexon_seq,@n ,17) When 'A' Then 0 When 'C' Then 1 When 'G' Then 2 When 'T' Then 3 End)
                      --+      17179869184*(Case Substring(ue.uexon_seq,@n ,18) When 'A' Then 0 When 'C' Then 1 When 'G' Then 2 When 'T' Then 3 End)
    	        From hla_uexon ue
    	        Where  Len(ue.uexon_seq)>= @n+@hash_len-1
    	    Select @n = @n+@hash_len
        End

    End


    -- **************************************************
    -- ������� Hash �� ������� c ������ �������
    -- **************************************************
    If 1=1
    Begin
        Select @max_n=Max(len(ue.uexon_seq))
            From hla_uexon ue
        Truncate Table hla_uexon_part2

        -- ==================================================
        -- ���� �� ������
        -- ����� � ������� �������
        -- ==================================================
        Select @n=1
        While @n<=@max_n-@hash_len+1
        Begin
            Print 'exon-part step='+Cast(@n As varchar(20))
    	    Insert hla_uexon_part2
    	      (
    	        uexon_iid
    	       ,epart_pos
    	       ,epart_hash
    	      )
    	    Select ue.uexon_iid
    	          , @n
    	          , dbo.sql_str_hash_get(Substring(ue.uexon_seq,@n ,@hash_len))
                      --        (Case Substring(ue.uexon_seq,@n ,1)  When 'A' Then 0 When 'C' Then 1 When 'G' Then 2 When 'T' Then 3 End)
                      --+       4*(Case Substring(ue.uexon_seq,@n ,2)  When 'A' Then 0 When 'C' Then 1 When 'G' Then 2 When 'T' Then 3 End)
                      --+      16*(Case Substring(ue.uexon_seq,@n ,3)  When 'A' Then 0 When 'C' Then 1 When 'G' Then 2 When 'T' Then 3 End)
                      --+      64*(Case Substring(ue.uexon_seq,@n ,4)  When 'A' Then 0 When 'C' Then 1 When 'G' Then 2 When 'T' Then 3 End)
                      --+     256*(Case Substring(ue.uexon_seq,@n ,5)  When 'A' Then 0 When 'C' Then 1 When 'G' Then 2 When 'T' Then 3 End)
                      --+    1024*(Case Substring(ue.uexon_seq,@n ,6)  When 'A' Then 0 When 'C' Then 1 When 'G' Then 2 When 'T' Then 3 End)
                      --+    4096*(Case Substring(ue.uexon_seq,@n ,7)  When 'A' Then 0 When 'C' Then 1 When 'G' Then 2 When 'T' Then 3 End)
                      --+   16384*(Case Substring(ue.uexon_seq,@n ,8)  When 'A' Then 0 When 'C' Then 1 When 'G' Then 2 When 'T' Then 3 End)
                      --+   65536*(Case Substring(ue.uexon_seq,@n ,9)  When 'A' Then 0 When 'C' Then 1 When 'G' Then 2 When 'T' Then 3 End)
                      --+  262144*(Case Substring(ue.uexon_seq,@n ,10) When 'A' Then 0 When 'C' Then 1 When 'G' Then 2 When 'T' Then 3 End)
                      --+ 1048576*(Case Substring(ue.uexon_seq,@n ,11) When 'A' Then 0 When 'C' Then 1 When 'G' Then 2 When 'T' Then 3 End)
                      --+ 4194304*(Case Substring(ue.uexon_seq,@n ,12) When 'A' Then 0 When 'C' Then 1 When 'G' Then 2 When 'T' Then 3 End)
                      --+      16777216*(Case Substring(ue.uexon_seq,@n ,13) When 'A' Then 0 When 'C' Then 1 When 'G' Then 2 When 'T' Then 3 End)
                      --+      67108864*(Case Substring(ue.uexon_seq,@n ,14) When 'A' Then 0 When 'C' Then 1 When 'G' Then 2 When 'T' Then 3 End)
                      --+      268435456*(Case Substring(ue.uexon_seq,@n ,15) When 'A' Then 0 When 'C' Then 1 When 'G' Then 2 When 'T' Then 3 End)
                      --+      1073741824*(Case Substring(ue.uexon_seq,@n ,16) When 'A' Then 0 When 'C' Then 1 When 'G' Then 2 When 'T' Then 3 End)
                      --+      4294967296*(Case Substring(ue.uexon_seq,@n ,17) When 'A' Then 0 When 'C' Then 1 When 'G' Then 2 When 'T' Then 3 End)
                      --+      17179869184*(Case Substring(ue.uexon_seq,@n ,18) When 'A' Then 0 When 'C' Then 1 When 'G' Then 2 When 'T' Then 3 End)
    	        From hla_uexon ue
    	        Where  Len(ue.uexon_seq)>= @n+@hash_len-1
            Select @n=@n+1
        End

    End

End