-- ==================================================
-- Таблица join
-- ==================================================
If Object_id('hla_result_join') Is Not null
    Drop table hla_result_join;

Create table hla_result_join (
     read_iid       Numeric(14)
    ,exon_iid       Numeric(14)
    ,k_forward_back Numeric(1)
    ,eq_Cnt         Numeric(12)
    ,genExon_CD     Varchar(10)
    ,read_seq       Varchar(Max)
    ,read_seqF      Varchar(Max)
)
Grant insert,update,delete,select on hla_result_join to public

-- ==================================================
-- Таблица выравнивания
-- ==================================================
If Object_id('hla_result_align') Is Not null
    Drop table hla_result_align;

Create table hla_result_align (
     read_iid   Numeric(14)
    ,read_seq   Varchar(Max)
    ,mask_seq   Varchar(Max)
    ,diff_seq   Varchar(Max)
    ,genExon_CD Varchar(10)
)
Grant insert,update,delete,select on hla_result_align to public

-- ==================================================
-- Clust
-- ==================================================
Select  ue.uexon_seq
       ,ue2.uexon_seq
        ,j.*
    From hla_result_join j
    Inner Join hla_uexon ue With (Nolock) On ue.uexon_iid=j.exon_iid
    left Join hla_uexon ue2 With (Nolock) On ue.uexon_half_iid=ue2.uexon_iid And ue2.k_forward_back=1 And ue.k_forward_back=2

Select  f_seq=ue2.uexon_seq
        ,b_seq=ue.uexon_seq
        ,ue.uexon_iid
        ,ue.uexon_half_iid
        ,ue2.uexon_iid
        ,j.*
    From hla_result_join j
    Inner Join hla_uexon ue With (Nolock) On ue.uexon_iid=j.exon_iid And ue.k_forward_back=2
    Inner Join hla_uexon ue2 With (Nolock) On ue.uexon_half_iid=ue2.uexon_iid And ue2.k_forward_back=1 


-- ==================================================
-- align
-- ==================================================
Select *
    From hla_result_align

Select *
    From hla_uexon ue
    Inner join hla_result_align a On ue.uexon_diff_seq=Substring(a.diff_seq,1,Len(ue.uexon_diff_seq))





Select *
    From hla_uexon

Select dbo.sql_str_rank_sdiff(
    'GACTTAAAAGACTGAGAAGGGCAGTCTTGTGGGTTTCTGTGTGCACTGGGTGGTAGGGCAGAGACTGGTACTCCGGTGGGACTCCACGACCCGGGACCCGAAGATGGGATGCCTCTAGTGTGACTGGTCCGTCGCCCTACCGCTCCTGGTTTGAGTCCTGTGGCTCGAACACCTCTGGTCCGGTCGTCCTCTACCTTGGAAGGTCTTCACCCGTCGACACCACCACGGAAGACCTCTTCTCGTCTCTATGTGCACGGTACACGTCGTGCTCCCCGACGGTCTCGGGGAGTGGGACTCTACCCCATTCCTCCCCCTACTCCCCAGTACACAGAAGAGTCTCTTTCGTCTTCGGGAC'
   ,'AACACCCAAAGACACACGTGACCCACCATCCCGTCTCTGACCATGAGGCCACCCTGAGGTGCTGGGCCCTGGGCTTCTACCCTGCGGAGATCACACTGACCTGGCAGTGGGATGGGGAGGACCAAACTCAGGACACCGAGCTTGTGGAGACCAGGCCAGCAGGAGATGGAACCTTCCAGAAGTGGGCAGCTGTGATGGTGCCTTCTGGAGAAGAGCAGAGATACACGTGCCATGTGCAGCACGAGGGGCTGCCGGAGCCCCTCACCCTGAGATGGG'
    )