/*    
    -- ==================================================
    -- Список уникальных epart с тчностью до экхона и гена
    -- ==================================================
    Select *
        From dna2_hla.dbo.hla_uexon_ugpart up
        Inner Join (
            Select Count(*) As cnt
                    ,up.epart_hash
                From dna2_hla.dbo.hla_uexon_ugpart up
                Group By up.epart_hash
                Having Count(*)>1
            ) As t On t.epart_hash=up.epart_hash
	    Where  1 = 1
        Order By up.epart_hash
            ,up.gen_cd
            ,up.uexon_num

    Update dna2_hla.dbo.hla_uexon_ugpart
        set k_dbl=0

    Update dna2_hla.dbo.hla_uexon_ugpart
    	Set    k_dbl = 1
    	From   dna2_hla.dbo.hla_uexon_ugpart gp
    	Where  gp.epart_hash In (Select up.epart_hash
    	                             From dna2_hla.dbo.hla_uexon_ugpart up
    	                             Group By up.epart_hash
    	                             Having Count(*)>1)



    Select Count(*) 
        From dna2_hla.dbo.hla_uexon_ugpart up
        where k_dbl=1



    Select *
        From dna2_hla.dbo.hla_uexon_ugpart up
        order by uexon_cnt

    Select Count(*) From hla_reads rd

*/
    -- ==================================================
    -- Алгоритм
    -- ==================================================
    Set NoCount On;
    -- DBCC FREEPROCCACHE
    DBCC DROPCLEANBUFFERS 

    Declare @n          Int
           ,@max_n      Int
           ,@hash_Len   Int

    -- ==================================================
    -- init
    -- ==================================================
    Select @hash_len = 12

    if Object_id('tempdb..#reads') Is Not null
        Drop table #reads
    if Object_id('tempdb..#reads_part1') Is Not null
        Drop table #reads_part1
    if Object_id('tempdb..#reads_part2') Is Not null
        Drop table #reads_part2
    
    Create table #reads_part1 (
         rpart_seq  varchar(12)
         ,read_iid  int
    )

    Create table #reads_part2 (
         rpart_seq  varchar(12)
        ,uexon_num  Smallint
        ,gen_cd     Varchar(10)
        ,read_iid   int
    )


    Select rd.*
           ,a_2 = Cast(0 As SmallInt)
           ,a_3 = Cast(0 As SmallInt)
           ,a_4 = Cast(0 As SmallInt)
           ,b_2 = Cast(0 As SmallInt)
           ,b_3 = Cast(0 As SmallInt)
           ,b_4 = Cast(0 As SmallInt)
           ,c_2 = Cast(0 As SmallInt)
           ,c_3 = Cast(0 As SmallInt)
           ,c_4 = Cast(0 As SmallInt)
           ,dpb1_2 = Cast(0 As SmallInt)
           ,dpb1_3 = Cast(0 As SmallInt)
           ,dqb1_2 = Cast(0 As SmallInt)
           ,dqb1_3 = Cast(0 As SmallInt)
           ,drb1_2 = Cast(0 As SmallInt)
           ,drb1_3 = Cast(0 As SmallInt)
        Into #reads
        From hla_reads rd

    Select @max_n=Max(len(hr.read_seq))
        From #reads hr

Select 'start'
    -- ==================================================
    -- Цикл по данным
    -- Старт с каждого символа
    -- ==================================================
    Select @n=1
    While @n<=@max_n-@hash_len+1
    Begin
        Print 'read-part step='+Cast(@n As varchar(20))

        Delete from #reads_part1
        Delete from #reads_part2

        Insert into #reads_part1 (
             rpart_seq  
             ,read_iid
        )
        Select Substring(rd.read_seq,@n ,@hash_len) 
                ,rd.read_iid
            From #reads rd
    	    Where Len(rd.read_seq)>= @n+@hash_len-1

        Insert into #reads_part2 (
             rpart_seq  
            ,uexon_num  
            ,gen_cd     
            ,read_iid
        )
        Select rd.rpart_seq
                ,gp.uexon_num
                ,gp.gen_cd
                ,read_iid
            From #reads_part1 rd
            Inner Join dna2_hla.dbo.hla_uexon_ugpart gp With (Nolock Index=[hla_uexon_ugpart_idx2]) 
                On gp.epart_seq=rd.rpart_seq
                And gp.uexon_cnt=1

        Update #reads   
                Set  a_2 = case when gp.gen_cd='A' and gp.uexon_num=2 then rd.a_2+1 Else rd.a_2 End
                    ,a_3 = case when gp.gen_cd='A' and gp.uexon_num=3 then rd.a_3+1 Else rd.a_3 end
                    ,a_4 = case when gp.gen_cd='A' and gp.uexon_num=4 then rd.a_4+1 Else rd.a_4 end
                    ,b_2 = case when gp.gen_cd='B' and gp.uexon_num=2 then rd.b_2+1 Else rd.b_2 End
                    ,b_3 = case when gp.gen_cd='B' and gp.uexon_num=3 then rd.b_3+1 Else rd.b_3 end
                    ,b_4 = case when gp.gen_cd='B' and gp.uexon_num=4 then rd.b_4+1 Else rd.b_4 end
                    ,c_2 = case when gp.gen_cd='C' and gp.uexon_num=2 then rd.c_2+1 Else rd.c_2 End
                    ,c_3 = case when gp.gen_cd='C' and gp.uexon_num=3 then rd.c_3+1 Else rd.c_3 end
                    ,c_4 = case when gp.gen_cd='C' and gp.uexon_num=4 then rd.c_4+1 Else rd.c_4 end

                    ,dpb1_2 = case when gp.gen_cd='DPB1' and gp.uexon_num=2 then rd.dpb1_2+1 Else rd.dpb1_2 End
                    ,dpb1_3 = case when gp.gen_cd='DPB1' and gp.uexon_num=3 then rd.dpb1_3+1 Else rd.dpb1_3 End

                    ,dqb1_2 = case when gp.gen_cd='DQB1' and gp.uexon_num=2 then rd.dqb1_2+1 Else rd.dqb1_2 End
                    ,dqb1_3 = case when gp.gen_cd='DQB1' and gp.uexon_num=3 then rd.dqb1_3+1 Else rd.dqb1_3 End

                    ,drb1_2 = case when gp.gen_cd='DRB1' and gp.uexon_num=2 then rd.drb1_2+1 Else rd.drb1_2 End
                    ,drb1_3 = case when gp.gen_cd='DRB1' and gp.uexon_num=3 then rd.drb1_3+1 Else rd.drb1_3 End

            From #reads rd
            Inner Join #reads_part2 gp With (Nolock) On rd.read_iid=gp.read_iid

        Select @n=@n+1
    End

/*
    Select Count(*)
        From #reads   

    Select Count(*)
        From #reads   
        Where a_2+a_3+a_4+b_2+b_3+b_4+c_2+c_3+c_4+dpb1_2+dpb1_3+dqb1_2+dqb1_3+drb1_2+drb1_3=0

    Select Count(*)
        From #reads   
        Where a_2+a_3+a_4+b_2+b_3+b_4+c_2+c_3+c_4+dpb1_2+dpb1_3+dqb1_2+dqb1_3+drb1_2+drb1_3=1

    Select Count(*)
        From #reads   
        Where a_2+a_3+a_4+b_2+b_3+b_4+c_2+c_3+c_4+dpb1_2+dpb1_3+dqb1_2+dqb1_3+drb1_2+drb1_3>1
    
    Select Top 1000 *
        From #reads   
        Where a_2+a_3+a_4+b_2+b_3+b_4+c_2+c_3+c_4+dpb1_2+dpb1_3+dqb1_2+dqb1_3+drb1_2+drb1_3>1

    Select Top 1000 *
        From #reads   
        Where a_2+a_3+a_4+b_2+b_3+b_4+c_2+c_3+c_4+dpb1_2+dpb1_3+dqb1_2+dqb1_3+drb1_2+drb1_3>1
            --And b_2>a_2
            And drb1_2>10

    Select Count(*)
        From #reads   
        Where a_2>0 or a_3>0 Or a_4>0


    Select Count(*)
        From #reads   
        Where b_2>0 or b_3>0 Or b_4>0


    Select *
        from hla_join
        where read_iid=3504

    Select *
        from hla_reads_part
        where read_iid=3504


*/