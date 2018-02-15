-- ==================================================
-- yu.shirokov 20.11.2017
-- Удалить ранее загруженные НЕ классические гены
-- ==================================================
-- Пример выполнения
-- ==================================================
/*
	create Procedure [dbo].[hla2_None_Classic_Genes_delete] as Begin declare @i int; end
	Grant execute on [hla2_None_Classic_Genes_delete] to public
*/
-- ==================================================
Alter Procedure [dbo].[hla2_None_Classic_Genes_delete]
As
Begin


    Print '=================================================='
    Print '*** [hla2_noneclassicgenes_delete]'
    
	delete from hla_features where allele_id in (select al.allele_id from hla_alleles al where al.release_status='NoneClassicGen')
	delete from hla_alleles where release_status='NoneClassicGen'

end
