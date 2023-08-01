library(dplyr)
library(stringr)
library(tibble)
fastq <- list.files("data/fastq/", pattern = "*.fastq.gz$")

# nextflow needs a samplesheet with the following columns:
# sample, fastq_1, fastq_2, strandedness

samplesheet <- 
  tibble(
    sample = fastq %>% str_extract("\\w{6}-\\d{4}-\\d{2}-\\d{2}") %>% unique(),
    fastq_1 = paste0("/home/projects/cu_10181/people/tuhu/PAXgene/data/fastq/", sample, "_R1_001.fastq.gz"),
    fastq_2 = paste0("/home/projects/cu_10181/people/tuhu/PAXgene/data/fastq/", sample, "_R2_001.fastq.gz"),
    strandedness = "auto"
  )

c(samplesheet$fastq_1, samplesheet$fastq_2) %>% file.exists() %>% mean

readr::write_csv(samplesheet, "data/nextflow_input.csv")
