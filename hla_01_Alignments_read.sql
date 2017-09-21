-- ****************************************************************************************************
-- Загрузка данных файлов alignments 
-- ****************************************************************************************************

-- ****************************************************************************************************
-- Чтения
-- ****************************************************************************************************
	Use DNA_HLA

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
