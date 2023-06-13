library(dplyr)
library(stringr)
library(tibble)
fastq <- list.files("data/fastq/", pattern = "*.fastq.gz$")

var1 <- fastq %>% str_extract("\\w{6}")
var2 <- fastq %>% str_extract("\\d{4}-\\d{2}-\\d{2}")
fn <- paste(var1, var2, sep = "-")

samplesheet <- 
  tibble(
    sample = fn,
    fastq_1 = paste0("/home/projects/cu_10181/people/tuhu/PAXgene/data/fastq/", fn, "_R1_001.fastq.gz"),
    fastq_2 = paste0("/home/projects/cu_10181/people/tuhu/PAXgene/data/fastq/", fn, "_R2_001.fastq.gz"),
    strandedness = "auto"
  )

c(samplesheet$fastq_1, samplesheet$fastq_2) %>% file.exists() %>% mean

readr::write_csv(samplesheet, "data/nextflow_input.csv")
