Set Ansi_nulls On
Go
Set Quoted_identifier On
Go
use [DNA2_FASTQ]
Go
-- ==================================================
-- paley 28.08.2017
-- Загрузка данных fastQ
-- ==================================================
-- Пример выполнения
-- exec fastQ_Data_read @file_name='C:\WORK\NGS\DATA\2017_08_23-HLAi-I-II-example\IonXpress_032_21_07_17_115.fastq'
-- ==================================================
-- create Procedure [dbo].[fastQ2_Data_Read] as Begin declare @i int; end
-- Grant execute on [fastQ2_Data_Read] to public
-- ==================================================
Alter Procedure [dbo].[fastQ2_Data_Read]
	@file_name Varchar(Max)=Null
As
Begin
	Set Nocount On;

    -- ==================================================
	-- Declare
	-- ==================================================
	Declare @cData          varchar(max)
           ,@end_Num        Int
	       ,@beg_Num        Int
           ,@start_Num      Int
           ,@read_Str       varchar(max)
	       ,@data_id        varchar(50)
           ,@data_value     varchar(max)
           ,@cSql           nvarchar(max)
           ,@data_quality   varchar(max)

	-- ==================================================
	-- Прочитать из файла
	-- ==================================================
	Print '**************************************************'
	Print 'Чтение данных из файла:'+@file_name
	Print '**************************************************'
	Select @cSql = N'select @cData = cast(t.cData as varchar(max)) from openrowset(bulk '''+@file_name+''', single_clob) t(cData)';
	Exec sp_executesql @cSql
	    ,N'@cData varchar(max) output'
	    ,@cData Output;
	Select @cData

    -- ==================================================
    -- Цикл по данным , запись в файл сырвх данных hls_reads
    -- ==================================================
   	Truncate Table hla_reads

	Select @end_Num = 1
	      ,@beg_Num = 0

	While Isnull(@end_Num ,0)>0
	Begin
	    Select @start_Num   = @end_Num
	    Select @end_Num     = Charindex(Char(10) ,@cData ,@end_Num)
	    If Isnull(@end_Num ,0)>0
	    Begin
	        Select @read_Str = Substring(@cData ,@start_Num ,@end_Num-@start_Num)
	        Print '@start_Num='+Convert(Varchar(15) ,Isnull(@start_Num ,0))+' @end_Num='+Convert(Varchar(15) ,Isnull(@end_Num ,0))+' @read_Str='+@read_Str
	        --if substring(@read_Str,1,7)='@CXZDV:'
	        If Substring(@read_Str ,1 ,1)='@' And @beg_Num In (0 ,4)
	            Select @beg_Num         = 1
	                  ,@data_id         = @read_Str
	                  ,@data_value      = ''
	                  ,@data_quality    = ''
	        Else
	        Select @beg_Num = @beg_Num+1

	        If @beg_Num=2
	        Begin
	            If Substring(@read_Str ,1 ,1) In ('A' ,'C' ,'G' ,'T' ,'N')
	                Select @data_value = @read_Str
	            Else
	            Print 'Ошибка строки 2!'
	        End

	        If @beg_Num=3 And Substring(@read_Str ,1 ,1)<>'+'
	            Print 'Ошибка строки 3!'

	        If @beg_Num=4
	            Insert [hla_reads]
	              (
	                [read_session]
	               ,[read_file]
	               ,[read_datetime]
	               ,[read_cd]
	               ,[read_seq]
	               ,[read_qual]
                   ,[read_hash]
                   ,[read_len]
                   ,[k_forward_back]
	              )
	            Select @@spid
	                  ,@file_Name
	                  ,Getdate()
	                  ,@data_id
	                  ,@data_value
	                  ,@read_Str
                      ,Cast(Replace( Substring(@data_id,8,Len(@data_id)-7) ,':','') As Bigint)
                      ,Len(@data_value)
                      ,0

	        Select @end_Num = @end_Num+1
	    End
	End

    -- ==================================================
    -- Оставим только хорошие данные :) 
    -- ==================================================
    Delete 
        from hla_reads
        Where len(read_seq)<=140


End
