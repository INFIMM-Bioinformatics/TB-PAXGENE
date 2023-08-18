# GEO Submission
library(dplyr)
library(stringr)


se <- readRDS("data/salmon.merged.gene_counts.rds")

metadata <-
  tibble(library_name = colnames(se)) %>% 
  mutate(animal = library_name %>% str_extract("[:alnum:]{1,6}"),
         sample_date = library_name %>% str_extract("[:digit:]{4}\\.[:digit:]{2}\\.[:digit:]{2}"),
         vaccine = case_when(
           animal %in% c("CFL098", "CGB091", "CGB093", "CGB097", "CGB104") ~ "CAF10b",
           animal %in% c("CFL069", "CGA054", "CGB065", "CGB088", "CGC010") ~ "CAF09hi"
         ),
         timepoint = case_when(
           sample_date == "2019.06.24" ~ "baseline", # pre-immunization
           sample_date == "2019.06.25" ~ "immu1", # day 1 after immunization 1
           sample_date == "2019.07.23" ~ "immu2" # day 1 after immunization 2
         ),
         title = paste("blood", vaccine, timepoint, "rep 1", sep = ", "),
         description = title,
         organism = "Macaca fascicularis",
         tissue = "blood",
         raw_file_read1 = library_name %>% str_replace_all("\\.", "-") %>% paste0("_R1_001.fastq.gz"),
         raw_file_read2 = library_name %>% str_replace_all("\\.", "-") %>% paste0("_R1_002.fastq.gz"),
         processed_data_file = "count_matrix.tsv"
         ) %>% 
  dplyr::select(library_name, title, organism, tissue, vaccine, timepoint, sample_date, 
                processed_data_file, raw_file_read1, raw_file_read2)

openxlsx::write.xlsx(metadata, "data/geo_submission_metadata.xlsx")

count_matrix <- 
  se %>% assay(1) %>% as.matrix() %>% round()

write.table(count_matrix, file = "data/count_matrix.tsv", sep = "\t")


# count_matrix <- read.table(file = "count_matrix.tsv", sep = "\t")
