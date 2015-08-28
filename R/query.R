#' Execute a SOQL query
#'
#' Passes a SOQL query to the Force REST API. If the results of the query are
#' too large then a next records url is returned along with the partial results.
#'
#' @param .conn A \code{force_api} object.
#' @param qry A character vector SOQL query, see SOQL section below for
#'   details.
#' @param get_next A boolean value indicating that next records URLs should be
#'   followed
#'
#' @return A list of two values, \code{next_records_url} and \code{results}.
#'   NOTE, if \code{get_next} is \code{TRUE}, \code{next_records_url} will be
#'   \code{NA}.
#'
#' @importFrom magrittr %>%
#' @importFrom httr GET content
#' @importFrom dplyr bind_rows
#' @importFrom stringr str_replace_all
#' @export
query <- function(.conn, qry, get_next = TRUE, verbose = TRUE) {
  stopifnot(is.force_api(.conn), .conn$is_authorized(), !is.null(query))

  url <- qry %>%
    str_replace_all('\\s+', '+') %>%
    paste0(.conn$base, '/services/data/v', .conn$version, '/query?q=', .)

  query_more(.conn, url, get_next, verbose)
}

#' @keywords internal
#' @export
query_more <- function(.conn, query_url, get_next = TRUE, verbose = TRUE) {
  if (verbose) message(paste('Querying', query_url))

  query_response <- .conn$force_VERB('GET', query_url)

  suppressWarnings({
    query_results <- dplyr::bind_rows(
      query_response %>%
        content %>%
        .$records %>%
        lapply(function(rec) {
          unlisted_data <- rec %>% unlist

          fields <- Filter(function(nm) {
            !str_detect(nm, 'attributes')
          }, names(unlisted_data))

          if (length(fields) == 0) {
            stop('No valid fields returned by Salesforce')
          }

          relisted_subset <- append(list(), unlisted_data[fields])
          df <- data.frame(relisted_subset)
          colnames(df) %<>% str_replace_all('__r|__c|_', '')

          df
      })
    )
  })

  if (get_next & 'nextRecordsUrl' %in% (query_response %>% content %>% names)) {
    next_query <- paste0(.conn$base, httr::content(query_response)$nextRecordsUrl)

    query_results <- dplyr::bind_rows(query_results, query_more(.conn, next_query))
  }

  query_results
}
