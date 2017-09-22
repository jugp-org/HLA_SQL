 -- ****************************************************************************************************
 -- Сервис
 -- ****************************************************************************************************

 /*
 Declare @id     Bigint
        ,@sid    Varchar(50)
        ,@tid    Bigint
        ,@tsid   Varchar(50)
 Select @id  = 4765062  
 Select @sid = '210211320201'
 -- Select @sid = '013111013110323200'
 
 Select @tid=cast(Substring(@sid,1,1)
             +Substring(@sid,2,1)*4
             +Substring(@sid,3,1)*16
             +Substring(@sid,4,1)*64
             +Substring(@sid,5,1)*256
             +Substring(@sid,6,1)*1024
             +Substring(@sid,7,1)*4096
             +Substring(@sid,8,1)*16384
             +Substring(@sid,9,1)*65536
             +Substring(@sid,10,1)*262144
             +Substring(@sid,11,1)*1048576
             +Substring(@sid,12,1)*4194304
             --+Substring(@sid,13,1)*16777216
             --+Substring(@sid,14,1)*67108864
             --+cast(Substring(@sid,15,1) As Bigint)*268435456
             --+cast(Substring(@sid,16,1) As Bigint)*1073741824
             --+cast(Substring(@sid,17,1) As Bigint)*4294967296
             --+cast(Substring(@sid,18,1) As Bigint)*17179869184 
             As Bigint)
 
 
 Select @tsid = Cast((@tid % 4) As Varchar(1))
         +Cast((Floor (@tid/4) % 4) As Varchar(1))
         +Cast((FLOOR (@tid/16) % 4) As Varchar(1))
         +Cast((FLOOR (@tid/64) % 4) As Varchar(1))
         +Cast((FLOOR (@tid/256) % 4) As Varchar(1))
         +Cast((FLOOR (@tid/1024) % 4) As Varchar(1))
         +Cast((FLOOR (@tid/4096) % 4) As Varchar(1))
         +Cast((FLOOR (@tid/16384) % 4) As Varchar(1))
         +Cast((FLOOR (@tid/65536) % 4) As Varchar(1))
         +Cast((FLOOR (@tid/262144) % 4) As Varchar(1))
         +Cast((FLOOR (@tid/1048576) % 4) As Varchar(1))
         +Cast((FLOOR (@tid/4194304) % 4) As Varchar(1))
         --+Cast((FLOOR (@tid/16777216) % 4) As Varchar(1))
         --+Cast((FLOOR (@tid/67108864) % 4) As Varchar(1))
         --+Cast((FLOOR (@tid/268435456) % 4) As Varchar(1))
         --+Cast(Cast(FLOOR (@tid/1073741824) % 4 As Int) As Varchar(1))
         --+Cast(cast(FLOOR (@tid/4294967296) % 4 As int) As Varchar(1))
         --+Cast(cast(FLOOR (@tid/17179869184) % 4 As int) As Varchar(1))
 
 
 Select @sid,@tid,@tsid
 
 */
 
 -- ****************************************************************************************************
 -- Экзоны
 -- ****************************************************************************************************
    Select Substring(a.allele_name,1,Charindex('*',a.allele_name))
            ,Substring(a.allele_name,1,Charindex(':',a.allele_name))
            ,a.*
        From [dna_hla].[dbo].[hla_alleles] a
        Where 1=1
        Order By a.allele_name
--			and a.allele_name Like 'HLA-DRB1*%'
			--And a.release_confimed='confirmed' 

    -- Спсок экзонов
    Select a.allele_name
            ,f.feature_name
            ,f.feature_nucsequence
            ,f.*
        From [dna_hla].[dbo].hla_features f with (NoLock) 
		Inner Join dna_hla.dbo.hla_alleles a with (NoLock) On a.allele_id=f.allele_id 
        Where 1=1
			and f.feature_type = 'Exon'
			-- and f.feature_name in ('Exon 2','Exon 3','Exon 4')
            And (
                (f.feature_name='Exon 2' And a.allele_name Like 'HLA-D%')
                Or
                (f.feature_name in ('Exon 2','Exon 3','Exon 4') And Substring(a.allele_name,1,5) In ('HLA-A','HLA-B','HLA-C'))
            )
			and f.[feature_status]='Complete'
--			and a.allele_name Like 'HLA-DRB1*%'
			And a.release_confimed='confirmed' 
        Order by f.feature_name
                ,a.allele_name
                ,f.feature_nucsequence
		
    Select a.allele_name, a.release_confimed, f.*
        From dna_hla.dbo.hla_features f
        Inner Join hla_alleles a With (Nolock) On a.allele_id=f.allele_id


    Select f.feature_name
          ,f.feature_nucsequence
        From dna_hla..hla_features f
        Where  1 = 1
               And f.feature_type = 'Exon'
                   --and f.feature_name in ('Exon 2','Exon 3','Exon 4')
                   --and f.[feature_status]='Complete'
        Group By f.feature_name
                ,f.feature_nucsequence

    -- Список уникальных экзонов
    Select f.allele_id
          ,a.allele_name
          ,f.alignmentreference_alleleid
          ,e.*
        From dna_hla..hla_uexon e With (Nolock)
            Inner Join dna_hla.dbo.hla_features f With (Nolock) On f.feature_nucsequence = e.uexon_seq
            Inner Join dna_hla.dbo.[hla_alleles] a With (Nolock) On a.allele_id=f.allele_id
        Where 1=1
            and f.feature_name='Exon 2'
        Order By a.allele_name,f.alignmentreference_alleleid

    -- Кол-во уникальных экзонов по каждому типу гена
    Select Substring(a.allele_name,1,Charindex(':',a.allele_name))
            ,Count(*)
        From dna_hla..hla_uexon e With (Nolock)
            Inner Join dna_hla.dbo.hla_features f With (Nolock) On f.feature_nucsequence = e.uexon_seq
            Inner Join dna_hla.dbo.[hla_alleles] a With (Nolock) On a.allele_id=f.allele_id
        Where 1=1
            and f.feature_name='Exon 2'
        Group by Substring(a.allele_name,1,Charindex(':',a.allele_name))
        Order By Substring(a.allele_name,1,Charindex(':',a.allele_name))


    Select
           f.feature_name
          ,f.feature_nucsequence
          ,Count(*)
        From dna_hla.dbo.hla_features f
        Where  1 = 1
               And f.feature_type = 'Exon'
               And f.feature_name In ('Exon 2' ,'Exon 3' ,'Exon 4')
               And f.[feature_status] = 'Complete'
        Group By f.feature_name
                ,f.feature_nucsequence


	Select 
           e.*
	      ,Len(uexon_seq)
	    From dna_hla.dbo.hla_uexon e
	    Where  1 = 1
	           --and e.uexon_half_iid=1
	           --and e.k_forward_back=1
	           --and e.uexon_iid=17257
	    Order By e.uexon_half_iid
                ,e.uexon_iid
             --   ,e.uexon_seq
	            --,e.uexon_len_x
	            --,Len(uexon_seq)
	            --,uexon_name

 
    Select top 1000
            ep.*
            ,e.uexon_seq_x
            ,e.uexon_name
            ,e.uexon_len_x
        From dna_hla..hla_uexon_part ep With (Nolock)
            Inner Join dna_hla..hla_uexon e  With (Nolock) On e.[uexon_iid]=ep.[uexon_iid]
        Order By ep.[uexon_iid], ep.epart_pos
 
    Select Count(*) 
        From dna_hla..hla_uexon_part
    Select Count(*) 
        From dna_hla..hla_uexon_part2
 
 
    -- ****************************************************************************************************
    -- Чтения
    -- ****************************************************************************************************
    Select *
        from hla_wreads
        Where 1=1
    --        and read_iid=1
        And read_id=88903485
        Order By read_id

    Select Count(*)
        From hla_wreads
 
    -- ==================================================
    -- K-mers read
    -- ==================================================
    Select Count(*) 
        From hla_reads_part
 
    Select Distinct     
        read_id
        From hla_reads_part rp With (Nolock)
 
    Select top 500 
            rp.read_id
            , rp.rpart_pos
            , rp.rpart_seq_x
        from hla_reads_part rp With (Nolock)
        Order By rp.read_id,rp.rpart_pos
 
    Select Top 500 
        rp.read_id
        ,rp.rpart_pos
        ,rp.rpart_seq_x
        ,r.read_seq_x
        From hla_reads_part rp With (Nolock)
        Inner Join hla_wreads r With (Nolock)
            On r.read_id = rp.read_id
        Order By rp.read_id
                ,rp.rpart_pos
 
    -- ==================================================
    -- Уникальные вхождения в hla_reads_part
    -- ==================================================
    Select up.*
        From hla_reads_upart up
        Order By up.urpart_cnt 
 
    -- Статистика вхождений
    Select up.urpart_cnt
        ,k_mer_scnt = Count(*)
        ,k_mer_scnt = Count(*)*urpart_cnt
        From hla_reads_upart up
        Group By up.urpart_cnt
        Order By up.urpart_cnt

    Select Sum(urpart_cnt)
        From hla_reads_upart up
        Where urpart_cnt<6


    -- ****************************************************************************************************
    -- Сравнение чтений и экзонов
    -- ****************************************************************************************************
    -- ==================================================
	-- cross таблица
    -- ==================================================
    Select Top 1000 
            pc.* 
            ,ue.k_forward_back
            ,ue.*
        From hla_part_cross pc
        inner join dna_hla.dbo.hla_uexon ue With (Nolock)On ue.uexon_iid=pc.uexon_iid

    Select Count(*) from hla_part_cross
    Select Count(*) from (select distinct read_iid from hla_part_cross) As t

    Select Top 1000  pc.*
        From hla_part_cross pc
        Order By pc.read_iid


    Select Top 1000 wr.read_sid, wr.read_seq_x, rp.rpart_seq_x, rp.rpart_pos , pc.*
        From hla_part_cross pc
            Inner Join hla_wreads wr With (Nolock) On wr.read_iid=pc.read_iid
            Inner Join hla_reads_part rp With (Nolock) On rp.read_iid=pc.read_iid
        Order By pc.read_iid, rp.rpart_pos

    Select Count(*) 
        From (
            Select Distinct read_iid
                from hla_part_cross ) As t
    
    -- Совпадающие части по риду-экзону
    Select ep.*,ue.uexon_seq_x
        From dna_hla.dbo.hla_uexon ue
        inner Join dna_hla.dbo.hla_uexon_part ep With (Nolock) On ep.uexon_iid=ue.uexon_iid
        Where ue.uexon_iid=278
        Order By ep.epart_pos

    Select rp.*, wr.read_seq_x 
        From hla_wreads wr
        Inner Join hla_reads_part rp With (Nolock) On rp.read_iid=wr.read_iid
        Where wr.read_iid=18302
        Order By rp.rpart_pos 

    Select rp.rpart_id
            ,ep.epart_id
            ,rp.rpart_pos
            ,ep.epart_pos
            ,rp.rpart_seq_x
            ,ep.epart_seq_x
            ,ue.uexon_seq_x
        From dna_hla.dbo.hla_uexon ue
        inner Join dna_hla.dbo.hla_uexon_part ep With (Nolock) On ep.uexon_iid=ue.uexon_iid
        Inner Join hla_reads_part rp With (Nolock) On rp.read_iid=18302 And rp.rpart_id=ep.epart_id
        Where ue.uexon_iid=278
        Order By ep.epart_pos



    -- **************************************************
	-- hla_wreads_max таблица
    -- **************************************************
	Select count(*) from hla_wreads_max
	Select top 1000 * 
        from hla_wreads_max
        Order By uexon_iid

    Select Distinct read_iid
        from hla_wreads_max

    -- Список прямых/обратных ридов    
    Select distinct
            rm.read_iid
        From hla_wreads_max rm
            Inner Join DNA_HLA.dbo.hla_uexon ue With (Nolock) On ue.uexon_iid = rm.uexon_iid -- And ue.k_forward_back=2
        Where 1=1
            And ue.k_forward_back=2

    Select rm.*
        From hla_wreads_max rm
            Inner Join DNA_HLA.dbo.hla_uexon ue With (Nolock) On ue.uexon_iid = rm.uexon_iid -- And ue.k_forward_back=2
        Where 1=1
            And rm.k_forward_back=2

    -- Есть ли риды, похожие на прямые и обратные экзоны
    ;With _cte_read As (
        Select distinct
                rm.read_iid
            From hla_wreads_max rm
                Inner Join DNA_HLA.dbo.hla_uexon ue With (Nolock) On ue.uexon_iid = rm.uexon_iid 
            Where 1=1
                And rm.k_forward_back=1)
    Select distinct
            rm.read_iid
        From hla_wreads_max rm
            Inner Join DNA_HLA.dbo.hla_uexon ue With (Nolock) On ue.uexon_iid = rm.uexon_iid 
        Where 1=1
            And rm.k_forward_back=2
            And rm.read_iid In (Select read_iid From _cte_read)

    -- Расчет расстояния
    Update hla_wreads_max
        Set seq_distance = dbo.sql_str_distance_cnt_from_point(wr.read_seq_x,ue.uexon_seq_x, rm.rpart_pos_1,rm.epart_pos_1)
        From hla_wreads_max rm
            Inner Join hla_wreads wr With (Nolock) On wr.read_iid=rm.read_iid
            Inner Join DNA_HLA.dbo.hla_uexon ue With (Nolock) On ue.uexon_iid = rm.uexon_iid -- And ue.k_forward_back=2
            Inner Join DNA_HLA.dbo.hla_features f With (Nolock) On f.feature_nucsequence=ue.uexon_seq
            Inner Join DNA_HLA.dbo.hla_alleles a With (Nolock) On a.allele_id=f.allele_id
        Where 1=1
            -- and ue.epart_cnt>20
            And ue.uexon_name='Exon 2'
            And a.allele_name Like '%DQB%'
            And rm.uexon_iid In (1111000278,597)
        
	-- Расчет Diff
    Select   a.allele_name
            ,uexon_iid        = ue.uexon_iid
            ,rm.read_iid
            ,rm.seq_distance
            ,dbo.sql_str_distance_sdiff_from_point(wr.read_seq_x,ue.uexon_seq_x, rm.rpart_pos_1,rm.epart_pos_1)
            ,rm.rpart_pos_1
            ,rm.epart_pos_1
            ,rm.eq_cnt
            ,wr.read_seq_x 
            ,ue.uexon_seq_x
        From hla_wreads_max rm
            Inner Join hla_wreads wr With (Nolock) On wr.read_iid=rm.read_iid
            Inner Join DNA_HLA.dbo.hla_uexon ue With (Nolock) On ue.uexon_iid = rm.uexon_iid -- And ue.k_forward_back=2
            Inner Join DNA_HLA.dbo.hla_features f With (Nolock) On f.feature_nucsequence=ue.uexon_seq
            Inner Join DNA_HLA.dbo.hla_alleles a With (Nolock) On a.allele_id=f.allele_id
        Where 1=1
            -- and ue.epart_cnt>20
            And ue.uexon_name='Exon 2'
            And a.allele_name Like '%DQB%'
            And rm.uexon_iid In (1111000278,597)
        Order By ue.uexon_iid,rm.read_iid

	-- Список ридов для уникальных экзонов по определенному гену
    Select  f.feature_name
            ,a.allele_name
            ,uexon_iid        = ue.uexon_iid
            ,rm.read_iid
            ,rm.seq_distance
            -- ,dbo.sql_str_distance_sdiff_from_point(wr.read_seq_x,ue.uexon_seq_x, rm.rpart_pos_1,rm.epart_pos_1)
            ,wr.read_seq_x 
            ,ue.uexon_seq_x
            ,rm.k_forward_back
        From hla_wreads_max rm
            Inner Join hla_wreads wr With (Nolock) On wr.read_iid=rm.read_iid
            Inner Join DNA_HLA.dbo.hla_uexon ue With (Nolock) On ue.uexon_iid = rm.uexon_iid -- And ue.k_forward_back=2
            Inner Join DNA_HLA.dbo.hla_features f With (Nolock) On f.feature_nucsequence=ue.uexon_seq
            Inner Join DNA_HLA.dbo.hla_alleles a With (Nolock) On a.allele_id=f.allele_id
        Where 1=1
            and ue.uexon_name='Exon 2'
            And a.allele_name Like 'HLA-A*%'
            -- And rm.uexon_iid In (1111000278,597)
        Order By ue.uexon_iid,rm.read_iid

    -- Список ридов, похожих на 'Экзон N' и 'HLA-A*%'
    Select  Distinct
            rm.read_iid
            ,Substring(a.allele_name,1,Charindex('*',a.allele_name))
        From hla_wreads_max rm
            -- Inner Join hla_wreads wr With (Nolock) On wr.read_iid=rm.read_iid
            Inner Join DNA_HLA.dbo.hla_uexon ue With (Nolock) On ue.uexon_iid = rm.uexon_iid -- And ue.k_forward_back=2
            Inner Join DNA_HLA.dbo.hla_features f With (Nolock) On f.feature_nucsequence=ue.uexon_seq
            Inner Join DNA_HLA.dbo.hla_alleles a With (Nolock) On a.allele_id=f.allele_id
        Where 1=1
            -- and ue.uexon_name='Exon 3'
            -- And a.allele_name Like '%DPB%'
            -- And a.allele_name Like 'HLA-A*%'
            -- And a.allele_name Like '%DPB%'
        Order By rm.read_iid,Substring(a.allele_name,1,Charindex('*',a.allele_name))

    -- Кол-во ридов по генам
    ;With _cte_rcnt As (
        Select  rm.read_iid
                ,gen_name=Substring(a.allele_name,1,Charindex('*',a.allele_name))
            From hla_wreads_max rm
                -- Inner Join hla_wreads wr With (Nolock) On wr.read_iid=rm.read_iid
                Inner Join DNA_HLA.dbo.hla_uexon ue With (Nolock) On ue.uexon_iid = rm.uexon_iid -- And ue.k_forward_back=2
                Inner Join DNA_HLA.dbo.hla_features f With (Nolock) On f.feature_nucsequence=ue.uexon_seq
                Inner Join DNA_HLA.dbo.hla_alleles a With (Nolock) On a.allele_id=f.allele_id
            Where 1=1
                -- and ue.uexon_name='Exon 3'
                -- And a.allele_name Like '%DPB%'
                -- And a.allele_name Like 'HLA-A*%'
                -- And a.allele_name Like '%DPB%'
            Group By rm.read_iid,Substring(a.allele_name,1,Charindex('*',a.allele_name))
        )
    Select read_cnt=Count(*)
           ,gen_name
        From _cte_rcnt           
        Group By gen_name
        Order By gen_name


    -- Список ридов, похожих на 'Экзон N' 
    Select  Distinct
            rm.read_iid
        From hla_wreads_max rm
            -- Inner Join hla_wreads wr With (Nolock) On wr.read_iid=rm.read_iid
            Inner Join DNA_HLA.dbo.hla_uexon ue With (Nolock) On ue.uexon_iid = rm.uexon_iid -- And ue.k_forward_back=2
            Inner Join DNA_HLA.dbo.hla_features f With (Nolock) On f.feature_nucsequence=ue.uexon_seq
        Where 1=1
            and ue.uexon_name='Exon 3'
            -- And a.allele_name Like '%DPB%'
            -- And a.allele_name Like 'HLA-A*%'
        Order By rm.read_iid

    -- Проверка кластеризации
    -- выделим риды, одновременно похожие на разные экзоны или гены
    ;With _cte_uread As (
        Select  Distinct
                rm.read_iid
                ,gen_name=Substring(a.allele_name,1,Charindex('*',a.allele_name))
                ,ue.uexon_name
            From hla_wreads_max rm
                -- Inner Join hla_wreads wr With (Nolock) On wr.read_iid=rm.read_iid
                Inner Join DNA_HLA.dbo.hla_uexon ue With (Nolock) On ue.uexon_iid = rm.uexon_iid -- And ue.k_forward_back=2
                Inner Join DNA_HLA.dbo.hla_features f With (Nolock) On f.feature_nucsequence=ue.uexon_seq
                Inner Join DNA_HLA.dbo.hla_alleles a With (Nolock) On a.allele_id=f.allele_id
        )
    Select *
        From _cte_uread t1
        Inner Join _cte_uread t2 On t1.read_iid=t2.read_iid And (t1.gen_name<>t2.gen_name Or t1.uexon_name<>t2.uexon_name)
        Order By t1.uexon_name,t1.read_iid


	-- Количество совпавших ридов с каждым экзоном
    Select uexon_iid        = ue.uexon_iid
          ,uexon_name       = Max(ue.uexon_name)
          ,read_cnt         = count(*)          -- кол-во ридов в hla_wreads_max
        From hla_wreads_max rm
            Inner Join DNA_HLA.dbo.hla_uexon ue With (Nolock) On ue.uexon_iid = rm.uexon_iid -- And ue.k_forward_back=2
        Where 1=1
            -- and ue.uexon_name='Exon 4'
        Group By ue.uexon_name,ue.uexon_iid
        Order By ue.uexon_name,read_cnt,ue.uexon_iid

    -- Список ридов для экзона
    Select *
        From DNA_HLA.dbo.hla_uexon
        Where uexon_iid=17877

    Select rm.*, wr.read_seq, wr.read_seq_x
        From hla_wreads_max rm
            Inner Join hla_uexon ue With (Nolock) On ue.uexon_iid = rm.uexon_iid -- And ue.k_forward_back=2
            Inner Join hla_wreads wr With (Nolock) On wr.read_iid=rm.read_iid
        Where 1=1
            And ue.uexon_name='Exon 2'
            And rm.uexon_iid=17877

	-- Список ридов для даного типа гена по "Exon N"
    Select allele_id        = f.allele_id
          ,allele_name      = a.allele_name
          ,hla_g_group		= a.hla_g_group
          ,uexon_iid        = ue.uexon_iid
          ,uexon_name       = ue.uexon_name
          ,wr.read_iid
        From hla_wreads_max rm
			inner join hla_wreads wr with (NoLock) On wr.read_iid=rm.read_iid 
            Inner Join DNA_HLA.dbo.hla_uexon ue With (Nolock) On ue.uexon_iid = rm.uexon_iid -- And ue.k_forward_back=2
            Inner Join DNA_HLA.dbo.hla_features f With (Nolock) On f.feature_nucsequence=ue.uexon_seq
            Inner Join DNA_HLA.dbo.hla_alleles a With (Nolock) On a.allele_id=f.allele_id
        Where 1=1
            And ue.uexon_name='Exon 2'
            -- And a.allele_name Like '%DQB%'
            And a.allele_name Like '%A*%'
        Order By a.allele_name,f.allele_id,ue.uexon_iid


    -- ==================================================
    -- Анализ аллелей
    -- ==================================================
    Declare @gen Varchar(20)
    Select @gen='%HLA-A*%'
    Select @gen='%HLA-B*%'
    Select @gen='%HLA-C*%'
    
    ;With _cte_2 As (
        Select allele_id    = f.allele_id
              ,allele_name  = max(a.allele_name)
            From hla_wreads_max rm
                Inner Join hla_uexon ue With (Nolock)  On ue.uexon_iid = rm.uexon_iid and ue.uexon_name='Exon 2'
                Inner Join hla_features f With (Nolock) On f.feature_nucsequence=ue.uexon_seq
                Inner Join hla_alleles a With (Nolock) On a.allele_id=f.allele_id
            Where a.allele_name Like @gen
            Group By f.allele_id
            )
    , _cte_3 As (
        Select allele_id    = f.allele_id
              ,allele_name  = max(a.allele_name)
            From hla_wreads_max rm
                Inner Join hla_uexon ue With (Nolock) On ue.uexon_iid=rm.uexon_iid And ue.uexon_name='Exon 3'
                Inner Join hla_features f With (Nolock) On f.feature_nucsequence=ue.uexon_seq
                Inner Join hla_alleles a With (Nolock) On a.allele_id=f.allele_id
            Where a.allele_name Like @gen
            Group By f.allele_id
            )
    , _cte_4 As (
        Select allele_id    = f.allele_id
              ,allele_name  = max(a.allele_name)
            From hla_wreads_max rm
                Inner Join hla_uexon ue With (Nolock) On ue.uexon_iid=rm.uexon_iid And ue.uexon_name='Exon 4'
                Inner Join hla_features f With (Nolock) On f.feature_nucsequence=ue.uexon_seq
                Inner Join hla_alleles a With (Nolock) On a.allele_id=f.allele_id
            Where a.allele_name Like @gen
            Group By f.allele_id
            )
    Select c2.allele_id
            , Count(*)
            , c2.allele_name
        From _cte_2 c2
            Inner Join _cte_3 c3 With (Nolock) On c2.allele_id=c3.allele_id
            Inner Join _cte_4 c4 With (Nolock) On c2.allele_id=c4.allele_id
            Inner Join hla_alleles a With (Nolock) On a.allele_id=c2.allele_id
        Group By c2.allele_id,c2.allele_name
        Order By c2.allele_name


/*


 -- ==================================================
 
 -- Всего rpart
 Select Count(*)
     from #part rp With (Nolock)
 
 -- Всего разных read_id
 Select Distinct rp.read_id
     from #part rp With (Nolock)
 
 Select top 1000 rp.*
     from #part rp With (Nolock)
     Order By rp.read_id,rp.rpart_pos
 
 -- Риды у котрых есть одинаковые rpart_seq
 Select -- Top 1000
        read_id      = rp.read_id
       ,rpart_pos    = rp.rpart_pos
       ,uexon_iid     = ep.uexon_iid
       ,epart_pos    = ep.epart_pos
       ,diff_pos     = rp.rpart_pos-ep.epart_pos 
       ,ep.epart_seq_x
       ,e.uexon_name
     from #part rp With (Nolock Index=tmp_part_idx3)
         Inner Join hla_uexon_part ep With (Nolock) On ep.epart_id=rp.rpart_id 
         Inner Join hla_uexon e With (Nolock) On ep.uexon_iid=e.uexon_iid
     Where 1=1
         --and rp.read_id In (0
         --    --,201671
         --    --,502204
         --    -- ,203988
         --    ,105252
         --    )
         --And ep.uexon_iid in (13280)
      Order By rp.read_id,ep.uexon_iid,rp.rpart_pos,ep.epart_pos
 
 /*
    Select *
        From hla_uexon
        Where uexon_iid In (12583,12585,12629,12927,12929,13648)
 
    Select *
        From hla_wreads
        Where read_id=302114

     Select *
         From #part
         Where read_id=5913
         order by rpart_pos


    Select rpart_pos-28,rp.* , wm.*
        from #tread_part rp
            inner join hla_wreads_max wm on wm.wread_max_iid=rp.wread_max_iid
        where rp.wread_max_iid=1 
            and rp.read_id=5913 
        order by rp.rpart_pos

    Select ep.* , wm.*
        from #texon_part ep
            inner join hla_wreads_max wm on wm.wread_max_iid=ep.wread_max_iid
        where ep.wread_max_iid=1 
            and ep.uexon_iid=9356
        order by ep.epart_pos

    Select * From dna_hla.dbo.hla_uexon Where uexon_half_iid In (6742)
    Select * From dna_hla.dbo.hla_uexon Where uexon_iid In (21988)
    Select * From hla_wreads Where read_iid=54
    -- wread_max_iid=18
    Select * 
        From hla_wreads_max rm
        inner join dna_hla.dbo.hla_uexon e With (Nolock) on e.uexon_iid=rm.uexon_iid
        Where rm.wread_max_iid=18
            --read_iid=54 
            --and e.uexon_half_iid In (6742)
            --and e.uexon_iid=21988

-- Исходные перевернутые
e:CAGCCTCGCTCTGGTTGTAGCGGCGGAGCAGGTTCCTCAGGGCCACTCGGTCAGTCTGTGCGTTGGCCTTGGCGTACCCTGTGGTCCACTCCCAATACTGCGGCCCCTCTTGCTCCACCCACTGCTCCCGCGGCTCCATCCTCGGAATCGCGGCGTCGCTGTCGAACCGCAGGAATTGCGTGTCGTCTACGTACTCCACGGCGATGTAGCGGGGCTCCCCGCGGCCGGGCCGCGACACAGCGGTGCTGAAATACCTCAAGGAGTGGGAGC
r:CCCTGGCCGGGGTCACTCACCAGCCTCGCTCTGGTTGTAGCGGCGGAGCAGGTTCCTCAGGGCCACTCGGTCAGTCTGTGCGTTGGCCTTGGCGTACCCTGTTGTCCACTCCCAATACTGCGGCCCCTCTTGTTCCACCCACGGCTCCCGCGGCTCCATCCTCGGAATCGCGGCGTCGCTGTCGAACCGCAGGAATTGCGTGTCGTCTACGTACTCCACGGCGATGTAGCGGGGCTCCCCGCGGCCGGGCCGCGACACAGCGGTGCTGAGATACCTCAAGGAGTGGGAGCCTGGGGCGAGGAGGGGCTGAGACCTGCCCGACCCTCCTC
e:102113121313223323021221220210223311310222110131223102313232123322113322123011132322311013111003013212211113133213110111013213111212213110311312200312122123121323120011210220033212323123130123013110122120323021222213111121221122211212010102122321320003011310022023222021
r:11132211222231013101102113121313223323021221220210223311310222110131223102313232123322113322123011132332311013111003013212211113133233110111012213111212213110311312200312122123121323120011210220033212323123130123013110122120323021222213111121221122211212010102122321320203011310022023222021132222120220222213202011321112011131131

CCCTGGCCGGGGTCACTCACCAGCCTCGCTCTGGTTGTAGCGGCGGAGCAGGTTCCTCAGGGCCACTCGGTCAGTCTGTGCGTTGGCCTTGGCGTACCCTGTTGTCCACTCCCAATACTGCGGCCCCTCTTGTTCCACCCACGGCTCCCGCGGCTCCATCCTCGGAATCGCGGCGTCGCTGTCGAACCGCAGGAATTGCGTGTCGTCTACGTACTCCACGGCGATGTAGCGGGGCTCCCCGCGGCCGGGCCGCGACACAGCGGTGCTGAGATACCTCAAGGAGTGGGAGCCTGGGGCGAGGAGGGGCTGAGACCTGCCCGACCCTCCTC
GAGGAGGGTCGGGCAGGTCTCAGCCCCTCCTCGCCCCAGGCTCCCACTCCTTGAGGTATCTCAGCACCGCTGTGTCGCGGCCCGGCCGCGGGGAGCCCCGCTACATCGCCGTGGAGTACGTAGACGACACGCAATTCCTGCGGTTCGACAGCGACGCCGCGATTCCGAGGATGGAGCCGCGGGAGCCGTGGGTGGAACAAGAGGGGCCGCAGTATTGGGAGTGGACAACAGGGTACGCCAAGGCCAACGCACAGACTGACCGAGTGGCCCTGAGGAACCTGCTCCGCCGCTACAACCAGAGCGAGGCTGGTGAGTGACCCCGGCCAGGG

13113111021112311020231222202202122223112022232022001311030202312322120101021211222112212111131222212032302122101131032103132132321233002201211002132312132122121300221311301131221211131221011101133233131111221231030011131011323323111032122331122332123231320132213101122201311332201202212212032332231312131120110131013222211223111
20220222312221022313102111131131211110221311101311332022303131021011213232312122111221121222202111121301031211232202301230201201012100331132122331201021201211212033112022032202112122202112322232200100202222112102303322202322010010222301211002211001210102013201120232211132022001132131121121301001102021202213223202320111122110222

Вернули обратно
GCTCCCACTCCTTGAGGTATTTCAGCACCGCTGTGTCGCGGCCCGGCCGCGGGGAGCCCCGCTACATCGCCGTGGAGTACGTAGACGACACGCAATTCCTGCGGTTCGACAGCGACGCCGCGATTCCGAGGATGGAGCCGCGGGAGCAGTGGGTGGAGCAAGAGGGGCCGCAGTATTGGGAGTGGACCACAGGGTACGCCAAGGCCAACGCACAGACTGACCGAGTGGCCCTGAGGAACCTGCTCCGCCGCTACAACCAGAGCGAGGCTG
GAGGAGGGTCGGGCAGGTCTCAGCCCCTCCTCGCCCCAGGCTCCCACTCCTTGAGGTATCTCAGCACCGCTGTGTCGCGGCCCGGCCGCGGGGAGCCCCGCTACATCGCCGTGGAGTACGTAGACGACACGCAATTCCTGCGGTTCGACAGCGACGCCGCGATTCCGAGGATGGAGCCGCGGGAGCCGTGGGTGGAACAAGAGGGGCCGCAGTATTGGGAGTGGACAACAGGGTACGCCAAGGCCAACGCACAGACTGACCGAGTGGCCCTGAGGAACCTGCTCCGCCGCTACAACCAGAGCGAGGCTGGTGAGTGACCCCGGCCAGGG
e:213111013113320223033310210112132323121221112211212222021111213010312112322023012302012010121003311321223312010212012112120331120220322021121222021023222322021002022221121023033222023220110102223012110022110012101020132011202322111320220011321311211213010011020212022132
r:20220222312221022313102111131131211110221311101311332022303131021011213232312122111221121222202111121301031211232202301230201201012100331132122331201021201211212033112022032202112122202112322232200100202222112102303322202322010010222301211002211001210102013201120232211132022001132131121121301001102021202213223202320111122110222
 */
 
     -- ==================================================
     -- Количество совпадений каждого рида с экзонами
     -- ==================================================
     Select eq_cnt = Count(*)
           ,rp.read_id
           ,ep.uexon_iid
         Into #part_Cnt
         from #part rp With (Nolock Index=tmp_part_idx3)
             Inner Join hla_uexon_part ep With (Nolock) On ep.epart_id=rp.rpart_id 
             Inner Join hla_uexon e With (Nolock) On ep.uexon_iid=e.uexon_iid
             Inner Join hla_wreads r With (Nolock) On r.read_id=rp.read_id
         Where 1=1
            and e.uexon_len_x<=r.read_len_x
            --and rp.read_id In (0
            --    --,201671
            --    --,502204
            --    -- ,203988
            --    ,600664
            --    )
          Group by rp.read_id,ep.uexon_iid
 
     Create Index tmp_part_cnt_idx1 On #part_cnt(read_id,uexon_iid)
     Create Index tmp_part_cnt_idx2 On #part_cnt(read_id,eq_cnt)
 

      Select top 1000 *
         from #part_cnt rp With (Nolock)
         order By rp.read_id, rp.uexon_iid

      Select count(*)
         from #part_cnt rp With (Nolock)

     -- Всего разных read
     Select Distinct rp.read_id
         from #part_cnt rp With (Nolock)
 

     Select eq_cnt=Max(t.eq_cnt)
             ,t.read_id
         Into #part_cnt_max
         From #part_cnt t With (Nolock)
         Group By t.read_id
 
     Create Index tmp_part_cnt_max_dx1 On #part_cnt_max(read_id)
 
    -- Записать результат в постоянную таблицу
    If Object_id('hla_wreads_max') Is Not null
         Drop table hla_wreads_max
    Create table hla_wreads_max (
            wread_max_iid   Numeric(15) Identity(1,1)
            ,read_id        Bigint
            ,uexon_iid      Int
            ,uexon_name     varchar(20) 
            ,eq_cnt         Int
        )

    Insert hla_wreads_max (
            read_id        
            ,uexon_iid      
            ,uexon_name    
            ,eq_cnt   )     
     Select pc.read_id        
            ,pc.uexon_iid      
            ,e.uexon_name    
            ,pc.eq_cnt        
         from #part_Cnt pc With (Nolock Index=tmp_part_cnt_idx2)
             Inner Join #part_cnt_max pm With (Nolock) On pc.read_id=pm.read_id And pc.eq_cnt=pm.eq_cnt
             Inner Join hla_uexon e With (Nolock) On pc.uexon_iid=e.uexon_iid
         Where 1=1
             -- and pc.eq_cnt>7
         Order By pc.read_id, pc.uexon_iid
 
    Create Index hla_wreads_max_idx1 On hla_wreads_max(read_id,uexon_iid)
    Create Index hla_wreads_max_idx2 On hla_wreads_max(read_id,wread_max_iid)
    Create Index hla_wreads_max_idx3 On hla_wreads_max(uexon_iid,wread_max_iid)
    Create Index hla_wreads_max_idx4 On hla_wreads_max(eq_cnt,wread_max_iid)

    Select Top 1000 * 
        From hla_wreads_max
 
 
    -- ==================================================
    -- Всего #part_Cnt
    Select Count(*)
        from #part_Cnt rp With (Nolock)
 
    Select Count(*)
        from #part_cnt_max rp With (Nolock)
 
    Select Count(*)
        From hla_wreads_max
 
    Select *
        from hla_wreads_max hw
        Where hw.eq_cnt>3
        order by uexon_iid,read_id
 
    Select uexon_name, count(*)
        from hla_wreads_max
        Where eq_cnt>3
        Group By uexon_name
        Order By uexon_name
 
    Select eq_cnt, count(*)
        from hla_wreads_max
        Group By eq_cnt
        Order By eq_cnt
 
 
    Select distinct pc.read_id
        from #part_Cnt pc With (Nolock Index=tmp_part_cnt_idx2)
            Inner Join #part_cnt_max pm With (Nolock) On pc.read_id=pm.read_id And pc.eq_cnt=pm.eq_cnt
            Inner Join hla_uexon e With (Nolock) On pc.uexon_iid=e.uexon_iid
        Where pc.eq_cnt>9
        Order By pc.read_id
 

    Select max(eq_cnt)
        From hla_wreads_max
 
    Select Distinct read_iid 
        From hla_wreads_max

    Select Distinct read_iid 
        From hla_wreads
 
    -- ****************************************************************************************************
    -- Выравнивание
    -- ****************************************************************************************************
    Select top 100 *
        from hla_wreads_max
        Where uexon_iid=5250

    Select distinct read_iid,k_forward_back from hla_wreads_max

    Select distinct rm.read_iid,rm.k_forward_back 
        from hla_wreads_max rm
            Inner Join hla_uexon ue With (Nolock) On ue.uexon_iid = rm.uexon_iid 
        Where rm.k_forward_back=1

    Select read_cnt=Count(*)
          ,rm.uexon_iid
          ,uexon_name   = Max(ue.uexon_name)
          ,allele_id    = max(f.allele_id)
        From hla_wreads_max rm
            Inner Join hla_uexon ue With (Nolock) On ue.uexon_iid = rm.uexon_iid -- And ue.k_forward_back=2
            Inner Join hla_features f With (Nolock) On f.feature_nucsequence=ue.uexon_seq
        Group By rm.uexon_iid
        Order By read_cnt


    Select allele_id    = f.allele_id
          ,allele_name  = a.allele_name
          ,uexon_iid    = ue.uexon_iid
          ,uexon_name   = Max(ue.uexon_name)
          ,read_cnt     = Count(*)
        From hla_wreads_max rm
            Inner Join hla_uexon ue With (Nolock) On ue.uexon_iid = rm.uexon_iid -- And ue.k_forward_back=2
            Inner Join hla_features f With (Nolock) On f.feature_nucsequence=ue.uexon_seq
            Inner Join hla_alleles a With (Nolock) On a.allele_id=f.allele_id
        Where 1=1
            -- and ue.epart_cnt>20
            And ue.uexon_name='Exon 2'
        Group By a.allele_name,f.allele_id,ue.uexon_iid
        Order By a.allele_name,f.allele_id,ue.uexon_iid

        Для первого аллеля А 4тый экзон выравнивается на референс A*30:95_exon4, который отличается от A*11:01:01:01_exon4 одной заменой. Вследствие этого данный аллель определен только по 2му и 3му экзонам

    Select read_cnt=Count(*)
          ,rm.uexon_iid
          ,uexon_name   = Max(ue.uexon_name)
          ,allele_id    = max(f.allele_id)
        From hla_wreads_max rm
            Inner Join hla_uexon ue With (Nolock)
                   On ue.uexon_iid = rm.uexon_iid
                   And ue.uexon_name='Exon 2'
            Inner Join hla_features f With (Nolock) On f.feature_nucsequence=ue.uexon_seq
        Group By rm.uexon_iid
        Order By read_cnt

    Select read_cnt=Count(*)
          ,rm.uexon_iid
          ,uexon_name   = Max(ue.uexon_name)
          ,allele_id    = f.allele_id
        From hla_wreads_max rm
            Inner Join hla_uexon ue With (Nolock)
                   On ue.uexon_iid = rm.uexon_iid
                   And ue.uexon_name='Exon 2'
            Inner Join hla_features f With (Nolock) On f.feature_nucsequence=ue.uexon_seq
        Group By f.allele_id, rm.uexon_iid
        Order By f.allele_id, rm.uexon_iid, read_cnt



    ;With _cte_2 As (
        Select read_cnt=Count(*)
              ,uexon_iid    = rm.uexon_iid
              ,uexon_name   = Max(ue.uexon_name)
              ,allele_id    = f.allele_id
            From hla_wreads_max rm
                Inner Join hla_uexon ue With (Nolock)
                       On ue.uexon_iid = rm.uexon_iid
                       And ue.uexon_name='Exon 2'
                Inner Join hla_features f With (Nolock) On f.feature_nucsequence=ue.uexon_seq
            Group By f.allele_id,rm.uexon_iid
            )
    , _cte_3 As (
        Select read_cnt=Count(*)
              ,uexon_iid    = rm.uexon_iid
              ,uexon_name   = Max(ue.uexon_name)
              ,allele_id    = f.allele_id
            From hla_wreads_max rm
                Inner Join hla_uexon ue With (Nolock)
                       On ue.uexon_iid = rm.uexon_iid
                       And ue.uexon_name='Exon 3'
                Inner Join hla_features f With (Nolock) On f.feature_nucsequence=ue.uexon_seq
            Group By f.allele_id,rm.uexon_iid
            )
    , _cte_4 As (
        Select read_cnt=Count(*)
              ,uexon_iid    = rm.uexon_iid
              ,uexon_name   = Max(ue.uexon_name)
              ,allele_id    = f.allele_id
            From hla_wreads_max rm
                Inner Join hla_uexon ue With (Nolock)
                       On ue.uexon_iid = rm.uexon_iid
                       And ue.uexon_name='Exon 4'
                Inner Join hla_features f With (Nolock) On f.feature_nucsequence=ue.uexon_seq
            Group By f.allele_id,rm.uexon_iid
            )
    Select f.allele_id, Count(*), allele_name=Max(a.allele_name)
        From hla_wreads_max rm
            Inner Join hla_uexon ue With (Nolock)  On ue.uexon_iid=rm.uexon_iid
            Inner Join hla_features f With (Nolock) On f.feature_nucsequence=ue.uexon_seq
            Inner Join hla_alleles a With (Nolock) On a.allele_id=f.allele_id
        Where f.allele_id In (Select allele_id From _cte_2)
            And f.allele_id In (Select allele_id From _cte_3)
            And f.allele_id In (Select allele_id From _cte_4)
        Group By f.allele_id
        Order By allele_name,Count(*)

    Select rm.uexon_iid
          ,rm.eq_cnt
          ,uexon_name   = ue.uexon_name
          ,feature_name = f.feature_name
          ,allele_id    = f.allele_id
          ,read_iid     = rm.read_iid
        From hla_wreads_max rm
            Inner Join hla_uexon ue With (Nolock)
                   On ue.uexon_iid = rm.uexon_iid
                   -- And ue.uexon_name='Exon 2'
            Inner Join hla_features f With (Nolock) On f.feature_nucsequence=ue.uexon_seq
        Where f.allele_id='HLA05970'
        Order By f.allele_id,ue.uexon_name


    Select * From hla_alleles
    Select * from hla_uexon where uexon_iid=2023
    Select * from hla_wreads where read_iid=35709
    CACGTTTCTTGGAGTACTCTACGTCTGAGTGTCATTTCTTCAATGGGACGGAGCGGGTGCGGTTCCTGGACAGATACTTCCATAACCAGGAGGAGAACGTGCGCTTCGACAGCGACGTGGGGGAGTTCCGGGCGGTGACGGAGCTGGGGCGGCCTGATGCCGAGTACTGGAACAGCCAGAAGGACATCCTGGAAGACGAGCGGGCCGCGGTGGACACCTACTGCAGACACAACTACGGGGTTGTGGAGAGCTTCACAGTGCAGC AGCGAG
    CACGTTTCTTGGAGTACTCTACGTCTGAGTGTCATTTCTTCAATGGGACGGAGCGGGTGCGGTTCCTGGACAGATACTTCCATAACCAGGAGGAGAACGTGCGCTTCGACAGCGACGTGGGGGAGTTCCGGGCGGTGACGGAGCTGGGGCGGCCTGATGCCGAGTACTGGAACAGCCAGAAGGACATCCTGGAAGACGAGCGGGCCGCGGTGGACACCTACTGCAGACACAACTACGGGGTTGTGGAGAGCTTCACAGTGCAGC GGCGAG

    Select rm.*,a.*
        From hla_wreads_max rm
            Inner Join hla_uexon ue With (Nolock) On ue.uexon_iid = rm.uexon_iid
            Inner Join hla_features f With (Nolock) On f.feature_nucsequence=ue.uexon_seq
            Inner Join hla_alleles a With (Nolock) On a.allele_id=f.allele_id
        Where 1=1
--            and rm.read_iid=35709
--             And rm.uexon_iid In (2241,2023,1946,12744)
            And a.allele_id In ('HLA00797','HLA14833','HLA17283','HLA17459','HLA05970','HLA06820','HLA10315','HLA12415','HLA14887','HLA16646','HLA17431')
        Order By rm.read_iid, f.feature_name





Select Top 1000 *
    From hla_part_cross

Select Top 1000 *
    From hla_part_cross
*/


