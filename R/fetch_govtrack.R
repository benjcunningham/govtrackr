#' Retrieve data from the GovTrack.us API
#'
#' Queries a GovTrack.us API resource for a data set using server-side
#' filtering, sorting, and pagination.
#' @param res Resource identifier
#' @param filter Named list of query filters
#' @param sort Vector of fields on which to sort
#' @param limit Maximum number of results to return
#' @param offset Pagination index of results
#' @return Data frame of results. Note that observations are returned
#'   according to the structure returned by the server and may not be
#'   wholly atomic.
#' @export
fetch_govtrack <- function(res = "bill", filter, sort, limit, offset) {

  res_url <- resources$resource_url[which(resources$resource == res)]

  if (length(res_url) == 0) {
    stop("The resource `", res, "` does not exist at GovTrack.")
  }

  if(!missing(filter)) {

    bad_filters <- .bad_filters(res, filter)
    if (sum(bad_filters) > 0) {
      paste(names(filter)[bad_filters], collapse = "`, `") %>%
        stop("The following fields cannot be used for filtering: `",
             ., "`", call. = FALSE)
    }

  }

  query <- .create_query(res_url, filter, sort, limit, offset)
  df <- jsonlite::fromJSON(query)$objects

  return(df)

}

#' Intelligently separate params with ampersands
#'
#' @param x Character string
#' @rdname add_amp
#' @return The input string concatenated with `&` if it does not end
#'   with `?`, otherwise the input string.
#' @keywords internal
.add_amp <- function(x) {

  substr(x, nchar(x), nchar(x)) %>%
  {ifelse(. != "?", "&", "")} %>%
    paste0(x, .)

}

#' Identify improper filters
#'
#' @inheritParams fetch_govtrack
#' @rdname bad_filters
#' @return Named vector the same length as \code{filter} identifying
#' improper filters with 1 and proper filters with 0.
#' @keywords internal
.bad_filters <- function(res, filter) {

  sapply(stringr::str_extract(names(filter), "^.*(?=__)|^.*$"),
         function(x) !(x %in% fields$field[fields$resource == res &
                                           fields$filterable]))

}

#' Create API query string
#'
#' @param res_url Resource root URL
#' @inheritParams fetch_govtrack
#' @rdname create_query
#' @return Character string representing the constructed API query
#' @keywords internal
.create_query <- function(res_url, filter, sort, limit, offset) {

  q <- paste0(res_url, "?")

  if (!missing(filter)) {

    q <-
      paste0(names(filter), "=", filter) %>%
      paste(collapse = "&") %>%
      paste0(q, .)

  }

  if (!missing(sort)) {

    q <-
      paste(sort, collapse = "|") %>%
      paste0(.add_amp(q), "sort=", .)

  }

  if (!missing(limit)) {
    q <- paste0(.add_amp(q), "limit=", limit)
  }

  if (!missing(offset)) {
    q <- paste0(.add_amp(q), "offset=", offset)
  }

  return(q)

}
