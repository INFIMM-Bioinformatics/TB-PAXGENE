# INFIMM TB PAXGENE

[![R Code Quality](https://github.com/INFIMM-Bioinformatics/TB-PAXGENE/actions/workflows/r-code-quality.yml/badge.svg)](https://github.com/INFIMM-Bioinformatics/TB-PAXGENE/actions/workflows/r-code-quality.yml)
[![License](https://img.shields.io/badge/License-See%20LICENSE-blue.svg)](LICENSE)

Monkey blood PAXGENE tubes bulk RNA-seq analysis

## Prerequisites

- R version 4.3.2 or higher
- Bioconductor 3.17
- Nextflow 22.10.4 or higher (for RNA-seq mapping)
- Singularity/Apptainer (for containerized workflow execution)

## Setup

1. Clone this repository:
   ```bash
   git clone https://github.com/INFIMM-Bioinformatics/TB-PAXGENE.git
   cd TB-PAXGENE
   ```

2. Restore R environment using renv:
   ```R
   # Open R in the project directory
   # renv will automatically activate
   renv::restore()
   ```

3. Configure paths in `config.R` to match your system setup.

## Bioinformatics Methods

### Data availability

RNA-seq data for 30 samples has been deposited on GEO under the accession number: [GSE241235](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=gse241235)

### Reference genome and annotation

* Ensembl genome assembilies: Macaca_fascicularis_6.0 (GCA_011100615.1), [fasta file](https://ftp.ensembl.org/pub/release-109/fasta/macaca_fascicularis/dna/Macaca_fascicularis.Macaca_fascicularis_6.0.dna_rm.toplevel.fa.gz)

* Ensembl annotation release: 109, [gtf file]([https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/012/559/485/GCF_012559485.2_MFA1912RKSv2/GCF_012559485.2_MFA1912RKSv2_genomic.gtf.gz](https://ftp.ensembl.org/pub/release-109/gtf/macaca_fascicularis/Macaca_fascicularis.Macaca_fascicularis_6.0.109.gtf.gz)) 

### Data analysis pipeline

| File                                       | Description                                                        |
| ------------------------------------------ | ------------------------------------------------------------------ |
| analysis\0_generate_nextflow_input.R       | generate input file for nextflow                                   |
| analysis\1_RNA_SEQ_MAPPING.sh              | RNA-seq mapping by nf-core (STAR/Salmon)                           |
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

## Reproducibility

This project uses `renv` for R package management to ensure reproducibility. All package versions are locked in `renv.lock`.

### Configuration Management

Paths and parameters are centralized in `config.R`. To use this project:

1. Update `config.R` with your local paths, or
2. Set environment variables:
   - `REFERENCE_DIR`: Directory containing reference genome files
   - `REFERENCE_FASTA`: Path to reference FASTA file
   - `REFERENCE_GTF`: Path to GTF annotation file
   - `MAX_CPUS`: Maximum CPUs for analysis (default: 40)
   - `MAX_MEMORY`: Maximum memory for analysis (default: 170GB)

### Session Information

To ensure reproducibility, document your R session information:

```R
sessionInfo()
```

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on:
- Code standards
- Development workflow
- Documentation requirements
- Quality assurance

## Code Quality

This project maintains code quality through:
- **lintr**: Static code analysis
- **renv**: Package version management
- **Configuration management**: Centralized path management
- **Continuous Integration**: Automated quality checks via GitHub Actions

Quality metrics are tracked via the badge at the top of this README.

## License

See [LICENSE](LICENSE) file for details.
