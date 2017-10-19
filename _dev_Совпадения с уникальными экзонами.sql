Select *
    From hla_uexon
    Where 1=1
        and uexon_iid In (13323,3328,13313)
    

Select *
    From hla_uexon
    Where uexon_half_iid In (13827)

Select *
    From dna2_fastq.dbo.hla_reads
    Where read_iid In (46584,46635)

Select *
    From dna2_fastq.dbo.hla_reads
    Where read_hash In (45404920,506901720)

Select ue.*
    From dna2_hla.dbo.hla_uexon ue
    Where 1=1
         and ue.uexon_iid In (29078)

Select ue.uexon_iid
        ,ue.k_forward_back
        ,Count(*)
    From dna2_hla.dbo.hla_uexon ue
    Inner Join dna2_fastq.dbo.hla_reads r With (Nolock) On charindex(ue.uexon_seq,r.read_seq)>0
    Where 1=1
         and ue.uexon_half_iid In (13827)
    Group By ue.uexon_iid, ue.k_forward_back

Select ue.uexon_iid
        ,ue.k_forward_back
        ,ue.uexon_seq
        ,read_hash
        ,ue.*
        ,r.*
    From dna2_hla.dbo.hla_uexon ue
    Inner Join dna2_fastq.dbo.hla_reads r With (Nolock) On charindex(ue.uexon_seq,r.read_seq)>0
    Where 1=1
         and ue.uexon_half_iid In (13827)



-- ==================================================
-- Поиск точных совпадений
-- ==================================================
If Object_id('tempdb..#uexon_eq') Is Not null
    Drop table #uexon_eq

Create table #uexon_eq (
    uExon_iid           Numeric(14)
    ,eq_Cnt             Numeric(14)
    ,k_forward_back     Numeric(1)
)

Declare @uexon_iid  Numeric(14)
        ,@read_iid  Numeric(14)
        ,@n1        Numeric(14)

Select @uexon_iid=Min(uexon_iid) 
    From dna2_hla.dbo.hla_uexon ue

Select @n1=1

While Isnull(@uexon_iid,0)<>0
Begin

    Print '@n1='+Cast(@n1 As Varchar(20))+'   uexon_id='++Cast(@uexon_iid As Varchar(20))
	
    Insert #uexon_eq
        Select ue.uexon_iid
            ,Count(*)
            ,ue.k_forward_back
        From dna2_hla.dbo.hla_uexon ue With (Nolock)
        Inner Join dna2_fastq.dbo.hla_reads r With (Nolock) On charindex(ue.uexon_seq,r.read_seq)>0
        Where 1=1
            and ue.uexon_half_iid=@uexon_iid
        Group By ue.uexon_iid, ue.k_forward_back

    Select @uexon_iid=Min(uexon_iid) 
        From dna2_hla.dbo.hla_uexon ue
        Where uexon_iid>@uexon_iid

    Select @n1=@n1+1

End

