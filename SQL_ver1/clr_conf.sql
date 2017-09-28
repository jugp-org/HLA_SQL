sp_configure 'show advanced options', 1; 
GO 
RECONFIGURE; 
GO 
sp_configure 'clr enabled', 1; 
GO 
RECONFIGURE; 
Go


-- **************************************************
-- 
-- **************************************************
/*
Drop Function sql_str_distance
Drop procedure sql_str_distance_from_point
Drop Assembly mssql_dna 
*/
/*
Create assembly mssql_dna 
    from 'C:\WORK\PROJECT\C#\mssql_dna\bin\Debug\mssql_dna.dll' 
    -- with permission_set = unsafe 
Go
*/
Alter assembly mssql_dna 
    from 'C:\WORK\PROJECT\C#\mssql_dna\bin\Debug\mssql_dna.dll' 
Go
Select * From [sys].[assemblies]

Create Function sql_str_distance
(
	@inp_str      Nvarchar(Max)
   ,@tag_str      Nvarchar(Max)
)
Returns SmallInt
As External Name mssql_dna.[mssql_dna.sequence_lib].sql_str_distance

Create Function sql_str_distance_cnt_from_point
(
     @inp_str      Nvarchar(Max)
    ,@tag_str      Nvarchar(Max)
    ,@inp_pos      smallint
    ,@tag_pos      smallint
)
Returns SmallInt
As External Name mssql_dna.[mssql_dna.sequence_lib].sql_str_distance_cnt_from_point

Create Function sql_str_distance_sdiff_from_point
(
     @inp_str      Nvarchar(Max)
    ,@tag_str      Nvarchar(Max)
    ,@inp_pos      smallint
    ,@tag_pos      smallint
)
Returns Nvarchar(Max)
As External Name mssql_dna.[mssql_dna.sequence_lib].sql_str_distance_sdiff_from_point

Create Procedure sql_str_distance_from_point
(
     @inp_str      Nvarchar(Max)
    ,@tag_str      Nvarchar(Max)
    ,@inp_pos      smallint
    ,@tag_pos      smallint
    ,@res_distance smallint         out
    ,@res_inp_str  Nvarchar(Max)    out
    ,@res_tag_str  Nvarchar(Max)    out
    ,@res_diff_str Nvarchar(Max)    out
)
As External Name mssql_dna.[mssql_dna.sequence_lib].sql_str_distance_from_point

Create Function sql_str_rank_sdiff
(
     @inp_str      Nvarchar(Max)
    ,@tag_str      Nvarchar(Max)
)
Returns Nvarchar(Max)
As External Name mssql_dna.[mssql_dna.sequence_lib].sql_str_rank_sdiff


-- **************************************************
-- 
-- **************************************************
Select dbo.sql_str_distance('12345AA','12345s')
Go


-- **************************************************
-- test
-- **************************************************
Select top 10000
        wr.read_seq_x
        ,ue.uexon_seq_x
        ,dbo.sql_str_distance_sdiff_from_point(wr.read_seq_x,ue.uexon_seq_x, wm.rpart_pos_1,wm.epart_pos_1)
        --,wm.*
        --,wr.read_seq_x
        --,ue.uexon_seq_x
        --,wm.rpart_pos_1
        --,wm.epart_pos_1
    From hla_wreads_max wm With (Nolock)
    Inner Join hla_wreads wr With (Nolock) On wr.read_iid=wm.read_iid
    Inner Join DNA_HLA.dbo.hla_uexon ue With (Nolock) On ue.uexon_iid=wm.uexon_iid
    order by wm.wread_max_iid

Select top 10000
        wr.read_seq_x
        ,ue.uexon_seq_x
        ,dbo.sql_str_rank_sdiff(wr.read_seq_x,ue.uexon_seq_x)
        --,wm.*
        --,wr.read_seq_x
        --,ue.uexon_seq_x
        --,wm.rpart_pos_1
        --,wm.epart_pos_1
    From hla_wreads_max wm With (Nolock)
    Inner Join hla_wreads wr With (Nolock) On wr.read_iid=wm.read_iid
    Inner Join DNA_HLA.dbo.hla_uexon ue With (Nolock) On ue.uexon_iid=wm.uexon_iid
    order by wm.wread_max_iid

Select 10000/46

Select top 10
        dbo.sql_str_distance_cnt_from_point(wr.read_seq_x,ue.uexon_seq_x, wm.rpart_pos_1,wm.epart_pos_1)
        --,wm.*
        ,wr.read_seq_x
        ,ue.uexon_seq_x
        ,wm.rpart_pos_1
        ,wm.epart_pos_1
    From hla_wreads_max wm With (Nolock)
    Inner Join hla_wreads wr With (Nolock) On wr.read_iid=wm.read_iid
    Inner Join DNA_HLA.dbo.hla_uexon ue With (Nolock) On ue.uexon_iid=wm.uexon_iid

    
Select dbo.sql_str_distance_cnt_from_point(  
 '132013221122320331131210202203331232301102333002221032321301331011001222012202121232123133232011020301031303001120202202301210121331201021201232222232303122212232012112132222112113211211202301322001021102002200231132202022011122212202332201012232321020101001301102332202121121012011332102122120223202123123121111313232'
,'022033312323011023330022110323213013310110012220122021212321231332320110203010313030011202022023012101213312010212012322222323031222122320121121322221121132112112023013220010211020022002311322020220111222122023322010122323210201010013011023322021311210120113321021221202'
,26
,1)

