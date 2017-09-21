-- ****************************************************************************************************
-- Загрузка данных файлов alignments 
-- ****************************************************************************************************

-- ****************************************************************************************************
-- Чтения
-- ****************************************************************************************************
/*	
	Use DNA_HLA
	
	drop table hla_Alignments
	create table hla_Alignments (
		 allele_name	Varchar(20)
		,align_str		Varchar(max)
		,gen_pos		Int
		,cDNA_type		Int
		,main_seq		Int		
	)
	
    -- indexes
    -- Drop Index [hla_alignments].[hla_alignments_idx1]
    Create Nonclustered Index [hla_alignments_idx1] On [dbo].[hla_alignments] ([allele_name])
 
	-- права
	Grant Insert,Update,Delete,Select On hla_alignments To public


    -- Прочитать файл    
    -- Exec hla_Alignments_Read @file_name='D:\NGS\DATA\alignments\A_gen.txt'
    
    print '**************************************************'
    print 'Чтение данных alignments'
    print '**************************************************'
    Exec hla_Alignments_Read @file_name='D:\NGS\DATA\alignments\A_gen.txt'
    Exec hla_Alignments_Read @file_name='D:\NGS\DATA\alignments\B_gen.txt'
    Exec hla_Alignments_Read @file_name='D:\NGS\DATA\alignments\C_gen.txt'
    Exec hla_Alignments_Read @file_name='D:\NGS\DATA\alignments\DRB1_gen.txt'
    Exec hla_Alignments_Read @file_name='D:\NGS\DATA\alignments\DQB1_gen.txt'
    Exec hla_Alignments_Read @file_name='D:\NGS\DATA\alignments\DPB1_gen.txt'
    Go

    DBCC SHRINKFILE (N'DNA_HLA_log' , 0, TRUNCATEONLY)
    GO

*/


USE [DNA_HLA]
GO
/****** Object:  StoredProcedure [dbo].[fastQ_Data_Read]    Script Date: 21.09.2017 10:56:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================
-- shirokov 21.09.2017
-- Загрузка данных alignments - один файл!
-- ==================================================
-- Пример выполнения
-- Exec hla_Alignments_Read @file_name='D:\NGS\DATA\alignments\A_gen.txt'
-- ==================================================
-- create Procedure [dbo].[hla_Alignments_Read] as Begin declare @i int; end
-- Grant execute on [hla_Alignments_Read] to public
-- ==================================================
ALTER Procedure [dbo].[hla_Alignments_Read]
	@file_name Varchar(Max)=Null
As
Begin
	Set Nocount On;


-- пробуем!
--Declare @file_name Varchar(Max)
--select @file_name='D:\NGS\DATA\alignments\A_gen.txt'
--select @file_name='D:\NGS\DATA\alignments\A_nuc.txt'

    -- ==================================================
	-- Declare
	-- ==================================================
	Declare @cData          varchar(max)
           ,@end_Num        Int
	       ,@beg_Num        Int
           ,@start_Num      Int
           ,@str_cnt		Int
           ,@gen_pos		Int
           ,@cDNA_type		Int
           ,@main_seq		Int
           ,@allele_name	Varchar(20)
           ,@align_str		Varchar(200)
           ,@del_gen		Varchar(10)	
           ,@read_Str       varchar(max)
	       ,@data_id        varchar(50)
           ,@data_value     varchar(max)
           ,@cSql           nvarchar(max)
           ,@data_quality   varchar(max)
           
	-- ==================================================
	-- Временные таблицы
	-- ==================================================
	If object_id('tempdb..#all') Is Not null
		Drop table #all
	
	Create table #all (
		 allele_name	Varchar(20)
		,align_str		Varchar(max)
		,gen_pos		Int
		,cDNA_type		Int
		,main_seq		Int		
	)

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
	    
	--Select @cData

    -- ==================================================
    -- Цикл по данным
    -- ==================================================
	Select @end_Num = 1
	      ,@beg_Num = 0
	      ,@str_cnt = 0
	      ,@gen_pos = 0
	      ,@del_gen = '@#$'
	      ,@cDNA_type = 0
	      ,@main_seq = 1

	While Isnull(@end_Num ,0)>0
	Begin
	    Select @start_Num   = @end_Num
	    Select @end_Num     = Charindex(Char(10) ,@cData ,@end_Num)
	    If Isnull(@end_Num ,0)>0
	    Begin
	        Select @read_Str = Substring(@cData ,@start_Num ,@end_Num-@start_Num)
	              ,@str_cnt  = @str_cnt+1
	        
	        Print '@start_Num='+Convert(Varchar(15) ,Isnull(@start_Num ,0))+' @end_Num='+Convert(Varchar(15) ,Isnull(@end_Num ,0))+' @read_Str='+@read_Str
	        
			----------------------
			-- Обработка строки --
			----------------------
	        If Rtrim(Ltrim(@read_Str))='|'
	            Select @beg_Num = Charindex('|',@read_Str)

	        If (Substring(@read_Str,2,4)='gDNA' Or Substring(@read_Str,2,4)='cDNA') And Isnumeric(ltrim(rtrim(Substring(@read_Str,6,200))))=1
	            Select @gen_pos = ltrim(rtrim(Substring(@read_Str,6,200)))
	            
	        If @cDNA_type=0 And Substring(@read_Str,2,4)='gDNA'
				Select @cDNA_type=1
				
	        If @cDNA_type=0 And Substring(@read_Str,2,4)='cDNA'
				Select @cDNA_type=2
			
			-- Запись в таблицы
	        If @beg_Num>0 And Charindex('*',substring(@read_Str,1,@beg_Num-1))>0
	        Begin
	        	
				-- подготовка данных
	        	Select @allele_name = ltrim(rtrim(substring(@read_Str,1,@beg_Num-1)))
	        	      ,@align_str   = replace(replace(ltrim(rtrim(substring(@read_Str,@beg_Num,200))),' ',''),'|','')
	        	
	        	-- Удаление старых данных
	        	If @del_gen<>Substring(@allele_name,1,Charindex('*',@allele_name))
	        	Begin
	        		select @del_gen=Substring(@allele_name,1,Charindex('*',@allele_name))
	        		Delete hla_alignments Where allele_name Like @del_gen+'%'
	        	end 
	        	
				-- Суммируем строки
				If Exists(Select 1 From #all Where allele_name=@allele_name)
					Update #all
					   Set align_str = rtrim(align_str)+ltrim(@align_str)
					Where allele_name=@allele_name
				Else
					Insert #all
					select 
						 @allele_name
						,@align_str
						,@gen_pos
						,@cDNA_type
						,@main_seq
						
				Select @main_seq = 0
					
	        End
	        Select @end_Num = @end_Num+1
	    End
	End

	-- запись данных
	Delete from hla_alignments Where allele_name In (Select distinct al.allele_name From #all al)
	        
	Insert hla_alignments
		select * from #all

End
