/*
Select * From [hla_features]

select  Count(*)
    from hla_features f with (nolock)
    where 1=1
        and f.feature_type ='Exon'
        and f.feature_name in ('Exon 2','Exon 3','Exon 4')
*/
------ ѕример поиска 
If Object_id('tempdb..#result') Is Not null
    Drop table #result

select    r.read_file
		, r.read_id
		, f.allele_id
		, f.feature_id
		, f.feature_name
		, f.[SequenceCoordinates_start]
		, f.[SequenceCoordinates_end]
		, charindex(rtrim(f.feature_nucsequence),r.read_data) as read_data_charindex
		, f.feature_nucsequence
		, r.read_data
into #result
from hla_reads r with (nolock)
	,hla_features f with (nolock)
where 1=1
    and f.feature_type ='Exon'
    and f.feature_name in ('Exon 2','Exon 3','Exon 4')
    and f.[feature_status]='Complete'
    -- And isNull(f.cDNAindel_type,'')=''
	and Len(r.read_data)>100
	and charindex(rtrim(f.feature_nucsequence),r.read_data)>0
	-- and len(f.feature_nucsequence)<=Len(r.read_data)
 ---- если у брать ссылку на r.read_id, то ищет долго!
	--and r.read_id='@CXZDV:00326:02286'

select * from #result
