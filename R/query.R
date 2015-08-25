#' Execute a SOQL query
#'
#' Passes a SOQL query to the Force REST API. If the results of the query are
#' too large then a next records url is returned along with the partial results.
#'
#' @param .conn A \code{force_api} object.
#' @param query A character vector SOQL query, see SOQL section below for
#'   details.
#' @param get_next A boolean value indicating that next records urls should be
#'   followed
#'
#' @return A list of two values, \code{next_records_url} and \code{results}.
#'   NOTE, if \code{get_next} is \code{TRUE}, \code{next_records_url} will be
#'   \code{NA}.
#'
#' @export
query <- function(.conn, query = NULL, get_next = FALSE, verbose = TRUE) {
  if (.conn %>% inherits('force_api') %>% not) {
    stop(paste('cannot query with connection of type', .conn %>% class))
  }

  if (query %>% is.null & query_more %>% is.null) {
    stop('must specify query or query_more')
  }

  base_url <- .conn$base
  sf_version <- .conn$version

  if (query %>% is.null) {
    query_url <- paste0(base_url, query_more)
  } else {
    query_url <- query %>%
      str_replace_all('\\s+', '+') %>%
      paste0(base_url, '/services/data/v', sf_version, '/query?q=', .)
  }

  query_response <- query_url %T>%
    cat('\n') %>%
    GET(add_headers(Authorization = paste('Bearer', sf_access_token)), verbose())

  tryCatch(
    stop_for_status(query_response),
    error = function(e) {
      error_msg <- query_response %>%
        content %>%
        unlist %>%
        unname

      stop(paste(error_msg, collapse = ' '), call. = FALSE)
    }
  )

  suppressWarnings({
    query_results <- query_response %>%
      content %>%
      .[['records']] %>%
      lapply(function(rec) {
        unlisted_data <- rec %>% unlist

        fields <- Filter(function(nm) {
          nm %>% str_detect('attributes') %>% not
        }, names(unlisted_data))

        if (fields %>% length %>% equals(0)) {
          stop('No valid fields returned by Salesforce')
        }

        relisted_subset <- append(list(), unlisted_data[fields])
        df <- data.frame(relisted_subset)
        colnames(df) %<>% str_replace_all('__r|__c|_', '')

        df
      }) %>%
      bind_rows
  })

  if ('nextRecordsUrl' %in% (query_response %>% content %>% names)) {
    query_results %<>% bind_rows(query_salesforce(query_more = content(query_response)[['nextRecordsUrl']]))
  }

  query_results
}
