library(dplyr)

fields <-
  read.csv('data-raw/fields.csv', stringsAsFactors = FALSE) %>%
  mutate(resource = factor(resource)) %>%
  mutate_each(funs(ifelse(is.na(.), FALSE, .)), filterable, sortable)

devtools::use_data(fields, overwrite = TRUE)
