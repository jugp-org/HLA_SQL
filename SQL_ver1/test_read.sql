Declare 
         @cXml      Varchar(Max)


Select @cXml=
'<?xml version="1.0" encoding="ISO-8859-1" ?>
<alleles xmlns="http://hla.alleles.org/xml" xmlns:xs="http://www.w3.org/2001/XMLSchema" xs:noNamespaceSchemaLocation="http://hla.alleles.org/xml/hla.xsd">
  <allele id="HLA00001" name="HLA-A*01:01:01:01" dateassigned="1989-08-01">
    <releaseversions firstreleased="1.0.0" lastupdated="1.0.0" currentrelease="3.29.0" releasestatus="Sequence unchanged" confirmed="Confirmed"/>
    <locus genesystem="HLA" locusname="HLA-A" hugogenename="HLA-A" class="I" />
    <cwd_catalogue cwd_status="Common" cwd_version="2.0.0" cwd_reference="http://doi.org/10.1111/tan.12093"/>
    <hla_g_group status="A*01:01:01G"/>
    <hla_p_group status="A*01:01P"/>
    <citations>
      <citation pubmed="3375250" authors="Parham P, Lomen CE, Lawlor DA, Ways JP, Holmes N, Coppin HL, Salter RD, Wan AM, Ennis PD" title="Nature of polymorphism in HLA-A, -B, and -C molecules" location="Proc Natl Acad Sci U S A 85:4005-9 (1988)." />
      <citation pubmed="2251137" authors="Girdlestone J" title="Nucleotide sequence of an HLA-A1 gene" location="Nucleic Acids Res 18:6701-6701 (1990)." />
      <citation pubmed="9349617" authors="Laforet M, Froelich N, Parissiadis A, Pfeiffer B, Schell A, Faller B, Woehl-Jaegle ML, Cazenave JP, Tongio MM" title="A nucleotide insertion in exon 4 is responsible for the absence of expression of an HLA-A*01 allele" location="Tissue Antigens 50:347-50 (1997)." />
      <citation pubmed="15140828" authors="Stewart CA, Horton R, Allcock RJ, Ashurst JL, Atrazhev AM, Coggill P, Dunham I, Forbes S, Halls K, Howson JM, Humphray SJ, Hunt S, Mungall AJ, Osoegawa K, Palmer S, Roberts AN, Rogers J, Sims S, Wang Y, Wilming LG, Elliott JF, de Jong PJ, Sawcer S, Todd JA, Trowsdale J, Beck S" title="Complete MHC haplotype sequencing for common disease gene mapping" location="Genome Res 14:1176-87 (2004)." />
      <citation pubmed="18193213" authors="Horton R, Gibson R, Coggill P, Miretti M, Allcok RJ, Almeida J, Forbes S, Gilbert JGR, Halls K, Harrow JL, Hart E, Howe K, Jackson DK, Palmer S, Roberts AN, Sims S, Stewart CA, Traherne JA, Trevanion S, Wilming L, Rogers J, de Jong PJ, Elliott JF, Sawcer S, Todd JA, Trowsdale J, Beck S" title="Variation analysis and gene annotation of eight MHC haplotypes: The MHC Haplotype Project" location="Immunogenetics 60:1-18 (2008)." />
      <citation pubmed="19735485" authors="Zhu F, He Y, Zhang W, He J, He J, Xu X, Yan L" title="Analysis of the complete genomic sequence of HLA-A alleles in the Chinese Han population." location="Int J Immunogenet 36:351-360 (2009)." />
      <citation pubmed="24673518" authors="Lu L, Xu YP" title="Genomic full-length sequence of two HLA-A alleles, A*01:01:01:01 and A*01:03, identified by cloning and sequencing." location="Tissue Antigens 83:423-424 (2014)." />
    </citations>
    <sourcexrefs>
      <xref acc="AJ278305" pid="CAB93537.1" />
      <xref acc="AL645935" />
      <xref acc="CR759913" pid="CAQ08202.1" />
      <xref acc="EU445470" pid="ACA34990.1" />
      <xref acc="GU812295" pid="ADE80886.1" />
      <xref acc="HG794373" />
      <xref acc="M24043" pid="AAA59652.1" />
      <xref acc="X55710" pid="CAA39243.1" />
      <xref acc="Z93949" pid="CAB07989.1" />
    </sourcexrefs>
    <sourcematerial>
      <species latinname="Homo sapiens" commonname="Human" ncbitaxon="9606" />
      <ethnicity><sample_ethnicity>Oriental</sample_ethnicity>
      <sample_ethnicity>Caucasoid</sample_ethnicity></ethnicity>
      <samples>
        <sample name="7550800303" />
        <sample name="APD" />
        <sample name="B4702" />
        <sample name="COX" />
        <sample name="LCL721" />
        <sample name="MOLT-4" />
        <sample name="PP" />
      </samples>
    </sourcematerial>
    <sequence>
      <alignmentreference allelename="A*01:01:01:01" alleleid="HLA00001" />
      <nucsequence>CAGGAGCAGAGGGGTCAGGGCGAAGTCCCAGGGCCCCAGGCGTGGCTCTCAGGGTCTCAGGCCCCGAAGGCGGTGTATGGATTGGGGAGTCCCAGCCTTGGGGATTCCCCAACTCCGCAGTTTCTTTTCTCCCTCTCCCAACCTACGTAGGGTCCTTCATCCTGGATACTCACGACGCGGACCCAGTTCTCACTCCCATTGGGTGTCGGGTTTCCAGAGAAGCCAATCAGTGTCGTCGCGGTCGCTGTTCTAAAGTCCGCACGCACCCACCGGGACTCAGATTCTCCCCAGACGCCGAGGATGGCCGTCATGGCGCCCCGAACCCTCCTCCTGCTACTCTCGGGGGCCCTGGCCCTGACCCAGACCTGGGCGGGTGAGTGCGGGGTCGGGAGGGAAACCGCCTCTGCGGGGAGAAGCAAGGGGCCCTCCTGGCGGGGGCGCAGGACCGGGGGAGCCGCGCCGGGAGGAGGGTCGGGCAGGTCTCAGCCACTGCTCGCCCCCAGGCTCCCACTCCATGAGGTATTTCTTCACATCCGTGTCCCGGCCCGGCCGCGGGGAGCCCCGCTTCATCGCCGTGGGCTACGTGGACGACACGCAGTTCGTGCGGTTCGACAGCGACGCCGCGAGCCAGAAGATGGAGCCGCGGGCGCCGTGGATAGAGCAGGAGGGGCCGGAGTATTGGGACCAGGAGACACGGAATATGAAGGCCCACTCACAGACTGACCGAGCGAACCTGGGGACCCTGCGCGGCTACTACAACCAGAGCGAGGACGGTGAGTGACCCCGGCCCGGGGCGCAGGTCACGACCCCTCATCCCCCACGGACGGGCCAGGTCGCCCACAGTCTCCGGGTCCGAGATCCACCCCGAAGCCGCGGGACTCCGAGACCCTTGTCCCGGGAGAGGCCCAGGCGCCTTTACCCGGTTTCATTTTCAGTTTAGGCCAAAAATCCCCCCGGGTTGGTCGGGGCGGGGCGGGGCTCGGGGGACTGGGCTGACCGCGGGGTCGGGGCCAGGTTCTCACACCATCCAGATAATGTATGGCTGCGACGTGGGGCCGGACGGGCGCTTCCTCCGCGGGTACCGGCAGGACGCCTACGACGGCAAGGATTACATCGCCCTGAACGAGGACCTGCGCTCTTGGACCGCGGCGGACATGGCAGCTCAGATCACCAAGCGCAAGTGGGAGGCGGTCCATGCGGCGGAGCAGCGGAGAGTCTACCTGGAGGGCCGGTGCGTGGACGGGCTCCGCAGATACCTGGAGAACGGGAAGGAGACGCTGCAGCGCACGGGTACCAGGGGCCACGGGGCGCCTCCCTGATCGCCTATAGATCTCCCGGGCTGGCCTCCCACAAGGAGGGGAGACAATTGGGACCAACACTAGAATATCACCCTCCCTCTGGTCCTGAGGGAGAGGAATCCTCCTGGGTTTCCAGATCCTGTACCAGAGAGTGACTCTGAGGTTCCGCCCTGCTCTCTGACACAATTAAGGGATAAAATCTCTGAAGGAGTGACGGGAAGACGATCCCTCGAATACTGATGAGTGGTTCCCTTTGACACCGGCAGCAGCCTTGGGCCCGTGACTTTTCCTCTCAGGCCTTGTTCTCTGCTTCACACTCAATGTGTGTGGGGGTCTGAGTCCAGCACTTCTGAGTCTCTCAGCCTCCACTCAGGTCAGGACCAGAAGTCGCTGTTCCCTTCTCAGGGAATAGAAGATTATCCCAGGTGCCTGTGTCCAGGCTGGTGTCTGGGTTCTGTGCTCTCTTCCCCATCCCGGGTGTCCTGTCCATTCTCAAGATGGCCACATGCGTGCTGGTGGAGTGTCCCATGACAGATGCAAAATGCCTGAATTTTCTGACTCTTCCCGTCAGACCCCCCCAAGACACATATGACCCACCACCCCATCTCTGACCATGAGGCCACCCTGAGGTGCTGGGCCCTGGGCTTCTACCCTGCGGAGATCACACTGACCTGGCAGCGGGATGGGGAGGACCAGACCCAGGACACGGAGCTCGTGGAGACCAGGCCTGCAGGGGATGGAACCTTCCAGAAGTGGGCGGCTGTGGTGGTGCCTTCTGGAGAGGAGCAGAGATACACCTGCCATGTGCAGCATGAGGGTCTGCCCAAGCCCCTCACCCTGAGATGGGGTAAGGAGGGAGATGGGGGTGTCATGTCTCTTAGGGAAAGCAGGAGCCTCTCTGGAGACCTTTAGCAGGGTCAGGGCCCCTCACCTTCCCCTCTTTTCCCAGAGCTGTCTTCCCAGCCCACCATCCCCATCGTGGGCATCATTGCTGGCCTGGTTCTCCTTGGAGCTGTGATCACTGGAGCTGTGGTCGCTGCCGTGATGTGGAGGAGGAAGAGCTCAGGTGGAGAAGGGGTGAAGGGTGGGGTCTGAGATTTCTTGTCTCACTGAGGGTTCCAAGCCCCAGCTAGAAATGTGCCCTGTCTCATTACTGGGAAGCACCTTCCACAATCATGGGCCGACCCAGCCTGGGCCCTGTGTGCCAGCACTTACTCTTTTGTAAAGCACCTGTTAAAATGAAGGACAGATTTATCACCTTGATTACGGCGGTGATGGGACCTGATCCCAGCAGTCACAAGTCACAGGGGAAGGTCCCTGAGGACAGACCTCAGGAGGGCTATTGGTCCAGGACCCACACCTGCTTTCTTCATGTTTCCTGATCCCGCCCTGGGTCTGCAGTCACACATTTCTGGAAACTTCTCTGGGGTCCAAGACTAGGAGGTTCCTCTAGGACCTTAAGGCCCTGGCTCCTTTCTGGTATCTCACAGGACATTTTCTTCCCACAGATAGAAAAGGAGGGAGTTACACTCAGGCTGCAAGTAAGTATGAAGGAGGCTGATGCCTGAGGTCCTTGGGATATTGTGTTTGGGAGCCCATGGGGGAGCTCACCCACCCCACAATTCCTCCTCTAGCCACATCTTCTGTGGGATCTGACCAGGTTCTGTTTTTGTTCTACCCCAGGCAGTGACAGTGCCCAGGGCTCTGATGTGTCTCTCACAGCTTGTAAAGGTGAGAGCTTGGAGGGCCTGATGTGTGTTGGGTGTTGGGTGGAACAGTGGACACAGCTGTGCTATGGGGTTTCTTTGCGTTGGATGTATTGAGCATGCGATGGGCTGTTTAAGGTGTGACCCCTCACTGTGATGGATATGAATTTGTTCATGAATATTTTTTTCTATAGTGTGAGACAGCTGCCTTGTGTGGGACTGAGAGGCAAGAGTTGTTCCTGCCCTTCCCTTTGTGACTTGAAGAACCCTGACTTTGTTTCTGCAAAGGCACCTGCATGTGTCTGTGTTCGTGTAGGCATAATGTGAGGAGGTGGGGAGAGCACCCCACCCCCATGTCCACCATGACCCTCTTCCCACGCTGACCTGTGCTCCCTCTCCAATCATCTTTCCTGTTCCAGAGAGGTGGGGCTGAGGTGTCTCCATCTCTGTCTCAACTTCATGGTGCACTGAGCTGTAACTTCTTCCTTCCCTATTAAAA</nucsequence>
      <feature id="1.1" order="1" featuretype="UTR" name="5 UTR">
        <SequenceCoordinates start="1" end="300" />
     </feature>
      <feature id="1.2" order="2" featuretype="Exon" name="Exon 1" status="Complete" >
        <SequenceCoordinates start="301" end="373" />
        <cDNACoordinates start="1" end="73"  readingframe="1" />
     </feature>
      <feature id="1.3" order="3" featuretype="Intron" name="Intron 1">
        <SequenceCoordinates start="374" end="503" />
     </feature>
      <feature id="1.4" order="4" featuretype="Exon" name="Exon 2" status="Complete" >
        <SequenceCoordinates start="504" end="773" />
        <cDNACoordinates start="74" end="343"  readingframe="3" />
     </feature>
      <feature id="1.5" order="5" featuretype="Intron" name="Intron 2">
        <SequenceCoordinates start="774" end="1014" />
     </feature>
      <feature id="1.6" order="6" featuretype="Exon" name="Exon 3" status="Complete" >
        <SequenceCoordinates start="1015" end="1290" />
        <cDNACoordinates start="344" end="619"  readingframe="3" />
     </feature>
      <feature id="1.7" order="7" featuretype="Intron" name="Intron 3">
        <SequenceCoordinates start="1291" end="1869" />
     </feature>
      <feature id="1.8" order="8" featuretype="Exon" name="Exon 4" status="Complete" >
        <SequenceCoordinates start="1870" end="2145" />
        <cDNACoordinates start="620" end="895"  readingframe="3" />
     </feature>
      <feature id="1.9" order="9" featuretype="Intron" name="Intron 4">
        <SequenceCoordinates start="2146" end="2247" />
     </feature>
      <feature id="1.10" order="10" featuretype="Exon" name="Exon 5" status="Complete" >
        <SequenceCoordinates start="2248" end="2364" />
        <cDNACoordinates start="896" end="1012"  readingframe="3" />
     </feature>
      <feature id="1.11" order="11" featuretype="Intron" name="Intron 5">
        <SequenceCoordinates start="2365" end="2806" />
     </feature>
      <feature id="1.12" order="12" featuretype="Exon" name="Exon 6" status="Complete" >
        <SequenceCoordinates start="2807" end="2839" />
        <cDNACoordinates start="1013" end="1045"  readingframe="3" />
     </feature>
      <feature id="1.13" order="13" featuretype="Intron" name="Intron 6">
        <SequenceCoordinates start="2840" end="2981" />
     </feature>
      <feature id="1.14" order="14" featuretype="Exon" name="Exon 7" status="Complete" >
        <SequenceCoordinates start="2982" end="3029" />
        <cDNACoordinates start="1046" end="1093"  readingframe="3" />
     </feature>
      <feature id="1.15" order="15" featuretype="Intron" name="Intron 7">
        <SequenceCoordinates start="3030" end="3198" />
     </feature>
      <feature id="1.16" order="16" featuretype="Exon" name="Exon 8" status="Complete" >
        <SequenceCoordinates start="3199" end="3203" />
        <cDNACoordinates start="1094" end="1098"  readingframe="3" />
     </feature>
      <feature id="1.17" order="17" featuretype="UTR" name="3 UTR">
        <SequenceCoordinates start="3204" end="3503" />
     </feature>
      <feature id="1.18" name="Translation" featuretype="Protein">
        <translation>MAVMAPRTLLLLLSGALALTQTWAGSHSMRYFFTSVSRPGRGEPRFIAVGYVDDTQFVRFDSDAASQKMEPRAPWIEQEGPEYWDQETRNMKAHSQTDRANLGTLRGYYNQSEDGSHTIQIMYGCDVGPDGRFLRGYRQDAYDGKDYIALNEDLRSWTAADMAAQITKRKWEAVHAAEQRRVYLEGRCVDGLRRYLENGKETLQRTDPPKTHMTHHPISDHEATLRCWALGFYPAEITLTWQRDGEDQTQDTELVETRPAGDGTFQKWAAVVVPSGEEQRYTCHVQHEGLPKPLTLRWELSSQPTIPIVGIIAGLVLLGAVITGAVVAAVMWRRKSSDRKGGSYTQAASSDSAQGSDVSLTACKV</translation>
      </feature>
    </sequence>
  </allele>
  <allele id="HLA02169" name="HLA-A*01:01:01:02N" dateassigned="2005-04-29">
    <releaseversions firstreleased="2.10.0" lastupdated="2.10.0" currentrelease="3.29.0" releasestatus="Sequence unchanged" confirmed="Unconfirmed"/>
    <locus genesystem="HLA" locusname="HLA-A" hugogenename="HLA-A" class="I" />
    <cwd_catalogue cwd_status="Not CWD defined" cwd_version="2.0.0" cwd_reference="http://doi.org/10.1111/tan.12093"/>
    <hla_g_group status="A*01:01:01G"/>
    <hla_p_group status="None"/>
    <sourcexrefs>
      <xref acc="AY973959" pid="AAX94768.1" />
    </sourcexrefs>
    <sourcematerial>
      <species latinname="Homo sapiens" commonname="Human" ncbitaxon="9606" />
      <ethnicity><sample_ethnicity>Caucasoid</sample_ethnicity></ethnicity>
      <samples>
        <sample name="CTM7681276" />
      </samples>
    </sourcematerial>
    <sequence>
      <alignmentreference allelename="A*01:01:01:01" alleleid="HLA00001" />
      <nucsequence>GATTGGGGAGTCCCAGCCTTGGGGATTCCCCAACTCCGCAGTTTCTTTTCTCCCTCTCCCAACCTACGTAGGGTCCTTCATCCTGGATACTCACGACGCGGACCCAGTTCTCACTCCCATTGGGTGTCGGGTTTCCAGAGAAGCCAATCAGTGTCGTCGCGGTCGCTGTTCTAAAGTCCGCACGCACCCACCGGGACTCAGATTCTCCCCAGACGCCGAGGATGGCCGTCATGGCGCCCCGAACCCTCCTCCTGCTACTCTCGGGGGCCCTGGCCCTGACCCAGACCTGGGCGGGTGAGTGCGGGGTCGGGAGGGAAACCGCCTCTGCGGGGAGAAGCAAGGGGCCCTCCTGGCGGGGGCGCAGGACCGGGGGAGCCGCGCCGGGAGGAGGGTCGGGCAGGTCTCAGCCACTGCTCGCCCCCAGGCTCCCACTCCATGAGGTATTTCTTCACATCCGTGTCCCGGCCCGGCCGCGGGGAGCCCCGCTTCATCGCCGTGGGCTACGTGGACGACACGCAGTTCGTGCGGTTCGACAGCGACGCCGCGAGCCAGAAGATGGAGCCGCGGGCGCCGTGGATAGAGCAGGAGGGGCCGGAGTATTGGGACCAGGAGACACGGAATATGAAGGCCCACTCACAGACTGACCGAGCGAACCTGGGGACCCTGCGCGGCTACTACAACCAGAGCGAGGACGGTGACCCCGGCCCGGGGCGCAGGTCACGACCCCTCATCCCCCACGGACGGGCCAGGTCGCCCACAGTCTCCGGGTCCGAGATCCACCCCGAAGCCGCGGGACTCCGAGACCCTTGTCCCGGGAGAGGCCCAGGCGCCTTTACCCGGTTTCATTTTCAGTTTAGGCCAAAAATCCCCCCGGGTTGGTCGGGGCGGGGCGGGGCTCGGGGGACTGGGCTGACCGCGGGGTCGGGGCCAGGTTCTCACACCATCCAGATAATGTATGGCTGCGACGTGGGGCCGGACGGGCGCTTCCTCCGCGGGTACCGGCAGGACGCCTACGACGGCAAGGATTACATCGCCCTGAACGAGGACCTGCGCTCTTGGACCGCGGCGGACATGGCAGCTCAGATCACCAAGCGCAAGTGGGAGGCGGTCCATGCGGCGGAGCAGCGGAGAGTCTACCTGGAGGGCCGGTGCGTGGACGGGCTCCGCAGATACCTGGAGAACGGGAAGGAGACGCTGCAGCGCACGGGTACCAGGGGCCACGGGGCGCCTCCCTGATCGCCTATAGATCTCCCGGGCTGGCCTCCCACAAGGAGGGGAGACAATTGGGACCAACACTAGAATATCACCCTCCCTCTGGTCCTGAGGGAGAGGAATCCTCCTGGGTTTCCAGATCCTGTACCAGAGAGTGACTCTGAGGTTCCGCCCTGCTCTCTGACACAATTAAGGGATAAAATCTCTGAAGGAGTGACGGGAAGACGATCCCTCGAATACTGATGAGTGGTTCCCTTTGACACCGGCAGCAGCCTTGGGCCCGTGACTTTTCCTCTCAGGCCTTGTTCTCTGCTTCACACTCAATGTGTGTGGGGGTCTGAGTCCAGCACTTCTGAGTCTCTCAGCCTCCACTCAGGTCAGGACCAGAAGTCGCTGTTCCCTTCTCAGGGAATAGAAGATTATCCCAGGTGCCTGTGTCCAGGCTGGTGTCTGGGTTCTGTGCTCTCTTCCCCATCCCGGGTGTCCTGTCCATTCTCAAGATGGCCACATGCGTGCTGGTGGAGTGTCCCATGACAGATGCAAAATGCCTGAATTTTCTGACTCTTCCCGTCAGACCCCCCCAAGACACATATGACCCACCACCCCATCTCTGACCATGAGGCCACCCTGAGGTGCTGGGCCCTGGGCTTCTACCCTGCGGAGATCACACTGACCTGGCAGCGGGATGGGGAGGACCAGACCCAGGACACGGAGCTCGTGGAGACCAGGCCTGCAGGGGATGGAACCTTCCAGAAGTGGGCGGCTGTGGTGGTGCCTTCTGGAGAGGAGCAGAGATACACCTGCCATGTGCAGCATGAGGGTCTGCCCAAGCCCCTCACCCTGAGATGGGGTAAGGAGGGAGATGGGGGTGTCATGTCTCTTAGGGAAAGCAGGAGCCTCTCTGGAGACCTTTAGCAGGGTCAGGGCCCCTCACCTTCCCCTCTTTTCCCAGAGCTGTCTTCCCAGCCCACCATCCCCATCGTGGGCATCATTGCTGGCCTGGTTCTCCTTGGAGCTGTGATCACTGGAGCTGTGGTCGCTGCCGTGATGTGGAGGAGGAAGAGCTCAGGTGGAGAAGGGGTGAAGGGTGGGGTCTGAGATTTCTTGTCTCACTGAGGGTTCCAAGCCCCAGCTAGAAATGTGCCCTGTCTCATTACTGGGAAGCACCTTCCACAATCATGGGCCGACCCAGCCTGGGCCCTGTGTGCCAGCACTTACTCTTTTGTAAAGCACCTGTTAAAATGAAGGACAGATTTATCACCTTGATTACGGCGGTGATGGGACCTGATCCCAGCAGTCACAAGTCACAGGGGAAGGTCCCTGAGGACAGACCTCAGGAGGGCTATTGGTCCAGGACCCACACCTGCTTTCTTCATGTTTCCTGATCCCGCCCTGGGTCTGCAGTCACACATTTCTGGAAACTTCTCTGGGGTCCAAGACTAGGAGGTTCCTCTAGGACCTTAAGGCCCTGGCTCCTTTCTGGTATCTCACAGGACATTTTCTTCCCACAGATAGAAAAGGAGGGAGTTACACTCAGGCTGCAAGTAAGTATGAAGGAGGCTGATGCCTGAGGTCCTTGGGATATTGTGTTTGGGAGCCCATGGGGGAGCTCACCCACCCCACAATTCCTCCTCTAGCCACATCTTCTGTGGGATCTGACCAGGTTCTGTTTTTGTTCTACCCCAGGCAGTGACAGTGCCCAGGGCTCTGATGTGTCTCTCACAGCTTGTAAAGGTGAGAGCTTGGAGGGCCTGATGTGTGTTGGGTGTTGGGTGGAACAGTGGACACAGCTGTGCTATGGGGTTTCTTTGCGTTGGATGTATTGAGCATGCGATGGGCTGTTTAAGGTGTGACCCCTCACTGTGATGGATATGAATTTGTTCATGAATATTTTTTTCTATAGTGTGAGACAGCTGCCTTGTGTGGGACTGAGAGGCAAGAGTTGTTCCTGCCCTTCCCTTTGTGACTTGAAGAACCCTGACTTTGTTTCTGCAAAGGCACCTGCATGTGTCTGTGTTCGTGTAGGCATAATGTGAGGAGGTGGGGAGAGCACCCCACCCCCATGTCCACCATGACCCT</nucsequence>
      <feature id="2169.1" order="1" featuretype="UTR" name="5 UTR">
        <SequenceCoordinates start="1" end="221" />
     </feature>
      <feature id="2169.2" order="2" featuretype="Exon" name="Exon 1" status="Complete" >
        <SequenceCoordinates start="222" end="294" />
        <cDNACoordinates start="1" end="73"  readingframe="1" />
     </feature>
      <feature id="2169.3" order="3" featuretype="Intron" name="Intron 1">
        <SequenceCoordinates start="295" end="424" />
     </feature>
      <feature id="2169.4" order="4" featuretype="Exon" name="Exon 2" status="Complete" >
        <SequenceCoordinates start="425" end="694" />
        <cDNACoordinates start="74" end="343"  readingframe="3" />
     </feature>
      <feature id="2169.5" order="5" featuretype="Intron" name="Intron 2">
        <SequenceCoordinates start="695" end="931" />
     </feature>
      <feature id="2169.6" order="6" featuretype="Exon" name="Exon 3" status="Complete" >
        <SequenceCoordinates start="932" end="1207" />
        <cDNACoordinates start="344" end="619"  readingframe="3" />
     </feature>
      <feature id="2169.7" order="7" featuretype="Intron" name="Intron 3">
        <SequenceCoordinates start="1208" end="1786" />
     </feature>
      <feature id="2169.8" order="8" featuretype="Exon" name="Exon 4" status="Complete" >
        <SequenceCoordinates start="1787" end="2062" />
        <cDNACoordinates start="620" end="895"  readingframe="3" />
     </feature>
      <feature id="2169.9" order="9" featuretype="Intron" name="Intron 4">
        <SequenceCoordinates start="2063" end="2164" />
     </feature>
      <feature id="2169.10" order="10" featuretype="Exon" name="Exon 5" status="Complete" >
        <SequenceCoordinates start="2165" end="2281" />
        <cDNACoordinates start="896" end="1012"  readingframe="3" />
     </feature>
      <feature id="2169.11" order="11" featuretype="Intron" name="Intron 5">
        <SequenceCoordinates start="2282" end="2723" />
     </feature>
      <feature id="2169.12" order="12" featuretype="Exon" name="Exon 6" status="Complete" >
        <SequenceCoordinates start="2724" end="2756" />
        <cDNACoordinates start="1013" end="1045"  readingframe="3" />
     </feature>
      <feature id="2169.13" order="13" featuretype="Intron" name="Intron 6">
        <SequenceCoordinates start="2757" end="2898" />
     </feature>
      <feature id="2169.14" order="14" featuretype="Exon" name="Exon 7" status="Complete" >
        <SequenceCoordinates start="2899" end="2946" />
        <cDNACoordinates start="1046" end="1093"  readingframe="3" />
     </feature>
      <feature id="2169.15" order="15" featuretype="Intron" name="Intron 7">
        <SequenceCoordinates start="2947" end="3115" />
     </feature>
      <feature id="2169.16" order="16" featuretype="Exon" name="Exon 8" status="Complete" >
        <SequenceCoordinates start="3116" end="3120" />
        <cDNACoordinates start="1094" end="1098"  readingframe="3" />
     </feature>
      <feature id="2169.17" order="17" featuretype="UTR" name="3 UTR">
        <SequenceCoordinates start="3121" end="3291" />
     </feature>
      <feature id="2169.18" name="Translation" featuretype="Protein">
        <translation>MAVMAPRTLLLLLSGALALTQTWAGSHSMRYFFTSVSRPGRGEPRFIAVGYVDDTQFVRFDSDAASQKMEPRAPWIEQEGPEYWDQETRNMKAHSQTDRANLGTLRGYYNQSEDGDPGPGRRSRPLIPHGRARSPTVSGSEIHPEAAGLRDPCPGRGPGAFTRFHFQFRPKIPPGWSGRGGARGTGLTAGSGPGSHTIQX</translation>
      </feature>
    </sequence>
  </allele>
</alleles>'


exec hla_XML_read
	@cXml = @cXml

/*



Select @cXml=
'<?xml version="1.0" encoding="ISO-8859-1" ?>
<alleles xmlns="http://hla.alleles.org/xml" xmlns:xs="http://www.w3.org/2001/XMLSchema" xs:noNamespaceSchemaLocation="http://hla.alleles.org/xml/hla.xsd">
  <allele id="HLA00001" name="HLA-A*01:01:01:01" dateassigned="1989-08-01">
    <hla_g_group status="A*01:01:01G"/>
    <hla_p_group status="A*01:01P"/>
  </allele>
  <allele id="HLA00002" name="HLA-A*01:01:01:02" dateassigned="1989-08-02">
    <hla_g_group status="A*01:01:01G"/>
    <hla_p_group status="A*01:01P"/>
  </allele>
</alleles>'

    If Charindex('<alleles xmlns="http://hla.alleles.org/xml" xmlns:xs="http://www.w3.org/2001/XMLSchema" xs:noNamespaceSchemaLocation="http://hla.alleles.org/xml/hla.xsd">',@cXml)>0
    Begin
	    Select @cXml=Replace(@cXml,'<alleles xmlns="http://hla.alleles.org/xml" xmlns:xs="http://www.w3.org/2001/XMLSchema" xs:noNamespaceSchemaLocation="http://hla.alleles.org/xml/hla.xsd">','<alleles>')
    End

	

    Declare @xml_id    int
    
    -- xml_Prepare
    Exec sp_xml_preparedocument @xml_id OUTPUT, @cXml
    
    Select *	
        From OpenXML (@xml_id, '/alleles/allele',2) 
	    With (
                    [id]       Varchar(50)  '@id',  
                    [hla_g_group] varchar(30) 'hla_g_group/@status' 
                ) t


	
	
	*/