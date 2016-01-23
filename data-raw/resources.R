library(dplyr)

resources <-
  read.csv('data-raw/resources.csv', stringsAsFactors = FALSE) %>%
  mutate(resource = factor(resource))

devtools::use_data(resources, overwrite = TRUE)
