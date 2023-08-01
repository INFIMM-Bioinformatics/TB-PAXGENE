# INFIMM TB PAXGENE

Monkey blood PAXGENE tubes bulk RNA-seq analysis

## Bioinformatics Methods

### Data availability

RNA-seq data for 30 samples has been deposited on GEO under the accession number: [GSExxxx]()

### Refernce genome and annotation

* Ensembl genome assembilies: Macaca_fascicularis_6.0 (GCA_011100615.1), [fasta file](https://ftp.ensembl.org/pub/release-109/fasta/macaca_fascicularis/dna/Macaca_fascicularis.Macaca_fascicularis_6.0.dna_rm.toplevel.fa.gz)

* Ensembl annotation release: 109, [gtf file]([https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/012/559/485/GCF_012559485.2_MFA1912RKSv2/GCF_012559485.2_MFA1912RKSv2_genomic.gtf.gz](https://ftp.ensembl.org/pub/release-109/gtf/macaca_fascicularis/Macaca_fascicularis.Macaca_fascicularis_6.0.109.gtf.gz)) 

### Data analysis pipeline

| File                                       | Description                                                        |
| ------------------------------------------ | ------------------------------------------------------------------ |
| analysis\0_generate_nextflow_input.R       | generate input file for nextflow                                   |
| analysis\1_RNA_SEQ_MAPPING.sh              | RNA-seq maaping by nf-core (STAR/Salmon)                           |
| analysis\2_RNA_SEQ_MAPPING_SALMON.sh       | RNA-seq mapping by nf-core (only Salmon)                           |
| analysis\3_RNAseq_data_cleaning.Rmd        | RNA-seq: data cleaning and QC                                      |
| analysis\1_RNAseq_downstream_1.Rmd         | Figure 4a - PCA plots                                              |
| analysis\5_vacc_pre_pathway_enrichment.qmd | Figure 4b - Bubble plot for fGSEA pathway enrichment analysis      |
| analysis\6_correlation_late_response.qmd   | Figure 4c - correlate early blood signature with late response     |
| renv.lock                                  | The version of R/Bioconductor packages was documented using `renv` |

### Methods

We processed the raw RNA-seq data by nf-core rnaseq (version 3.12.0) (doi: 10.1038/s41587-020-0439-x), a community-curated best practice workflow.

In brief, the sequence read quality was checked by fastqc. Then, the adapter and low-quality reads were trimmed by “Trim Galore!”. The reads were mapped to Macaca fascicularis reference genome 6.0 by HISAT2 (doi: 10.1038/s41587-019-0201-4), and annotated by Emsembl 109. The mapped counts were counted by Salmon (doi: 10.1038/s41587-019-0201-4).  

Two outlier samples were excluded, based on the drifted distribution of GC% content and PCA (Principal component analysis), which was presumably due to incomplete depletion of globulin. The gene expression values of these two outliers were imputed using the group mean for the downstream analysis.

PCA was performed on the top-1500 variable genes. The expression values were normalized to the library size, then log2-transformed added with pseudo count (+1).

We performed differential gene expression analysis using DESeq2, by comparing day 1 after immunization 1 or 2 to the baseline separately. Genes were identified as differentially expressed by passing the cutoff with the absolute log2 fold change > 1, and adjusted p-value < 0.05. The differentially expressed gene (DEG) lists was used for pathway enrichment analysis by fgsea (doi: 10.1101/060012).  

To correlate the early blood gene expression signature and late vaccine response, we first calculated a pathway score by gene set variation analysis (GSVA) (doi: 10.1186/1471-2105-14-7). Then, we calculated the correlation between the pathway score and the late response (day 28) by Spearman’s correlation test, then visualized by corrplot.  

We documented a reproducible workflow, available on GitHub (github.com/ssi-dk/INFIMM-TB-PAXGENE). RNA-seq data is deposited on GEO under the accession number, GSExxxx (pending approval).
