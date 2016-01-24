#' govtrackr
#'
#' Retrieve data from the GovTrack.us API
#'
#' @docType package
#' @name govtrackr
#' @importFrom magrittr %>%
NULL

# Quiets R CMD check NOTEs for `.` in pipelines
utils::globalVariables(c("."))

# Quiets R CMD check NOTEs for internal data
utils::globalVariables(c("fields", "resources"))
