#' Schemas of access points available at GovTrack.us
#'
#' A dataset containing partial data dictionaries of the eight API
#' resources accessible at GovTrack.us.
#'
#' @format A data frame with 132 observations and 4 variables:
#' \describe{
#'   \item{resource}{Name of access point}
#'   \item{field}{Field name}
#'   \item{filterable}{Boolean value representing whether the field is
#'     filterable}
#'   \item{sortable}{Boolean value representing whether the field is
#'     sortable}
#' }
#' @source \url{https://www.govtrack.us/developers/api}
"fields"

#' API access points available at GovTrack.us
#'
#' A dataset containing the name and other attributes of the eight API
#' resources accessible at GovTrack.us.
#'
#' @format A data frame with 8 observations and 3 variables:
#' \describe{
#'   \item{resource}{Name of access point}
#'   \item{description}{Description of the schema}
#'   \item{resource_url}{Root URL of access point}
#' }
#' @source \url{https://www.govtrack.us/developers/api}
"resources"
