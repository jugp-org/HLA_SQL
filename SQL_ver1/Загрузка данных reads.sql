-- ��������� �������
If object_id('tReads') Is Not null
    Drop table tReads
    
create table tReads (xCol varchar(MAX))

-- �������� �����
INSERT INTO tReads SELECT xCol FROM (SELECT * FROM OPENROWSET (BULK 'f:\NGS\HLA\IonXpress_032_21_07_17_115.fastq', SINGLE_CLOB) AS xCol) AS R(xCol)

-- ������
select len(xCol) from tReads

-- ���������
declare 
	 @file		varchar(max)
	,@startNum	int
	,@endNum	int
	,@strNum	int
	,@readStr	varchar(max)
	,@id		varchar(20)
	,@data_value	varchar(max)
	,@data_quality	varchar(max)
	,@file_name		varchar(100)

select @file=xCol 
		,@file_name='IonXpress_032_21_07_17_115.fastq'
	from tReads

truncate table hla_reads
--select @endNum=charindex(char(10),@file) from tReads

select @endNum=1
	  ,@strNum=0	
while isnull(@endNum,0)>0
begin
	select @startNum=@endNum
	select @endNum=charindex(char(10),@file,@endNum)
	if isnull(@endNum,0)>0
	begin
		select @readStr=substring(@file,@startNum,@endNum-@startNum)
		print '@startNum='+convert(varchar(15),isnull(@startNum,0))+' @endNum='+convert(varchar(15),isnull(@endNum,0))+' @readStr='+@readStr
		--if substring(@readStr,1,7)='@CXZDV:'
		if substring(@readStr,1,1)='@' and @strNum in (0,4)
			select @strNum=1
			      ,@id=@readStr
			      ,@data_value=''
			      ,@data_quality=''
		else
			select @strNum=@strNum+1

		if @strNum=2 
		begin
			if substring(@readStr,1,1) in ('A','C','G','T','N')
				select @data_value=@readStr
			else
				print '������ ������ 2!'
		end
			      
		if @strNum=3 and substring(@readStr,1,1)<>'+'
			print '������ ������ 3!'
			      
		if @strNum=4 
			insert [hla_reads](
				[read_session],
				[read_file],
				[read_datetime],
				[read_id],
				[read_data],
				[read_quality]
				)
			select 
				@@spid	
				,@file_name
				,getdate()
				,@id
				,@data_value
				,@readStr
		
		select @endNum=@endNum+1
	end
	
end

------ ������ ������ 
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
where f.feature_name in ('Exon 2','Exon 3')
	--and charindex(substring(f.feature_nucsequence,1,300),r.read_data)>0
	and charindex(rtrim(f.feature_nucsequence),r.read_data)>0
-- ���� � ����� ������ �� r.read_id, �� ���� �����!
	and r.read_id='@CXZDV:00326:02286'

select * from #result