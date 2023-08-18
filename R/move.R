library(dplyr)
files <- list.files("data/figure/", full.names = T)
files %>% basename()

destination <- file.path("C://Users/B291968/Sundhedsdatastyrelsen/SSI-CVR-INFIMM - TB Group/PAXGene data package/", files %>% basename())

file.copy(from = files, to = destination, overwrite = T)
