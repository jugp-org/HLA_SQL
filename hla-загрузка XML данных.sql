
-- **************************************************
-- HLA Data load
-- **************************************************
exec hla_XML_read 
    @file_name='C:\WORK\NGS\DATA\hla.xml\hla.xml '

-- Select * From hla_alleles
Select * From hla_features 
    Where feature_id='10513.4'
    Order By allele_id

/*
-- **************************************************
-- FastQ Data load
-- **************************************************
exec fastQ_Data_read 
    @file_name='C:\WORK\NGS\DATA\2017_08_23-HLAi-I-II-example\IonXpress_030_21_07_17_115.fastq'
Select * 
    From hla_reads

*/
/*

-- временная таблица
If object_id('tXml') Is Not null
    Drop table tXml
create table tXml (xCol varchar(MAX))

-- загрузка файла
INSERT INTO tXml SELECT xCol FROM (SELECT * FROM OPENROWSET (BULK 'C:\WORK\NGS\DATA\hla.xml\hla.xml ', SINGLE_CLOB) AS xCol) AS R(xCol)

-- размер
select len(xCol) from tXml

-- проверка
select * from tXml


-- Обработка
declare @cXml Varchar(max)
select @cXml=xCol from tXml 
exec hla_XML_read @cXml


Select * From hla_alleles
Truncate Table hla_alleles


select sxml = cast(xData as xml) from openrowset(bulk 'C:\WORK\NGS\DATA\hla.xml\hla.xml' , single_clob) as t(xData)


Insert Into #tXml Select xCol From ( Select * From Openrowset(Bulk 'C:\WORK\NGS\DATA\hla.xml\hla.xml ' ,Single_clob) As xCol  ) As R(xCol) 
*/