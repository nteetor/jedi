#' HTTP error checking
#'
#' Better handling for Salesforce error responses.
#'
#' @importFrom httr stop_for_status content
#' @importFrom magrittr %>%
#' @export
check_salesforce_response <- function(res){
  tryCatch(
    httr::stop_for_status(res),
    error = function(e) {
      error_msg <- httr::content(res) %>%
        unlist %>%
        unname

      stop(paste(error_msg, collapse = ' '), call. = FALSE)
  })
}
