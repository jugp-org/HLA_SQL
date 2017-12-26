-- ======================================================================
-- ======================================================================
-- Check alleles
-- ======================================================================
-- ======================================================================
Select a.*
    From hla3_alleles a
    Order By a.allele_name

Select a.allele_name
        ,f.*
    From hla3_alleles a
    Inner Join hla3_features f With (Nolock) On f.allele_iid=a.allele_iid
    Order By a.allele_name

-- Проверка на HLA базу
-- Список уникальных экзонов 
-- в привязке к исходным данным HLA2
Select f.allele_id
        ,a.allele_name
        ,f.feature_name
        ,na.allele_name
        ,ne.feature_name
        ,ne.feature_nucsequence
        ,f.feature_nucsequence
    From dna2_hla.dbo.hla_features f With (Nolock)
        Inner Join dna2_hla.dbo.[hla_alleles] a With (Nolock) On a.allele_id=f.allele_id
        left Join hla3_alleles na With (Nolock) On na.allele_name=a.allele_name
        left Join hla3_features ne With (Nolock) 
            on 1=1
            And ne.feature_name=f.feature_name
            And ne.feature_nucsequence=f.feature_nucsequence 
            And ne.allele_iid=na.allele_iid
    Where 1=1
            -- And (a.allele_name Like 'HLA-A*%' Or a.allele_name Like 'HLA-B*%' Or a.allele_name Like 'HLA-C*%')
            And f.feature_name In ('Exon 2','Exon 3','Exon 4')
            --And Isnull(na.allele_name,'')=''
    Order By a.allele_name,f.feature_name,f.alignmentreference_alleleid 


-- Проверка групп
Select a.allele_name
        ,a.hla_g_group
        ,a.hla_p_group
        ,na.allele_name
        ,na.hla_g_group
        ,na.hla_p_group
    From dna2_hla.dbo.[hla_alleles] a With (Nolock) 
        left Join hla3_alleles na With (Nolock) On na.allele_name=a.allele_name
    Where 1=1
        -- And na.hla_g_group<>a.hla_g_group 
    Order By a.allele_name

-- ======================================================================
-- ======================================================================
-- Check uexon
-- ======================================================================
-- ======================================================================
-- Список уникальных экзонов
Select *
    From hla3_uexon
    Order By uexon_iid

-- Список уникальных экзонов 
-- в привязке к исзодным данным
Select a.allele_name
        ,a.hla_g_group
        ,a.hla_p_group
        ,a.allele_id
        ,ue.*
    From hla3_uexon ue
        Left Join hla3_features f With (Nolock) On f.feature_nucsequence=ue.uexon_seq
        Left Join hla3_alleles a With (Nolock) On a.allele_iid=f.allele_iid And a.allele_name Like 'HLA-'+ue.gen_cd+'*%'
    Where 1=1
        --And a.allele_name Like 'HLA-A*%'
        --And ue.uexon_num=3
        And ue.uexon_half_iid=15262
    Order By 
        a.allele_name
        ,f.feature_name
        ,ue.uexon_iid

-- Двойные экзоны
;With _cte_dbl as (
        Select ue.uexon_uid
            From hla3_uexon ue
            Where ue.k_forward_back=1
            Group By ue.uexon_uid
            Having Count(*)>1
            )
Select a.allele_name
        ,a.hla_g_group
        ,a.hla_p_group
        ,ue.*
    From hla3_uexon ue
        Inner Join _cte_dbl t On t.uexon_uid=ue.uexon_uid
        Inner Join hla3_features f With (Nolock) On f.feature_nucsequence=ue.uexon_seq
        Inner Join hla3_alleles a With (Nolock) On a.allele_id=f.allele_id And a.allele_name Like 'HLA-'+ue.gen_cd+'*%'
    Order By 
        ue.uexon_iid
        ,a.allele_name
        ,f.feature_name
        
-- Проверка уникальности экзонов в пределеах одного гена
Select gen_cd,uexon_seq 
    From hla3_uexon
    Group By gen_cd,uexon_seq 
    having Count(*)>1

-- ==================================================
-- Список частей экзонов
-- ==================================================
Select Count(*) 
    From hla3_uexon_part
Select Count(*) 
    From hla3_uexon_part2

Select ep.*
        ,ue.uexon_seq
    from hla3_uexon_part ep
        inner join hla3_uexon ue on ue.uexon_iid=ep.uexon_iid
    where ep.uexon_iid<10
    order by ep.uexon_iid,ep.epart_pos


Select ep.*
        ,ue.uexon_seq
    from hla3_uexon_part2 ep
        inner join hla3_uexon ue on ue.uexon_iid=ep.uexon_iid
    where ep.uexon_iid<10
    order by ep.uexon_iid,ep.epart_pos

-- ==================================================
-- Экзоны для выравнивания
-- ==================================================
Select *
    from hla3_fexon_align
    Order By allele_name,exon_num



