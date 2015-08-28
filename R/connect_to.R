#' Connect to a Salesforce instance
#'
#' Start up a connection to a Salesforce instance.
#'
#' @param url A character vector of the instance URL
#' @param \dots Additional parameters required to authenticate the Force REST
#'   API, such as username, password, client_id, or client_secret
#'
#' @return A \code{force_api} R6 object
#'
#' @export
connect_to <- function(url, ...) {
  force_api$new(url, ...)
}
