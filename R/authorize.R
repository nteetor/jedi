#' Generate an OAuth 2.0 access token
#'
#' Uses the information stored in a \code{force_api} object to request an access
#' token from Salesforce.
#'
#' @inheritParams query
#' @importFrom httr POST content
#' @export
authorize <- function(.conn) {
  stopifnot(is.force_api(.conn))

  .conn$authorize_connection()

  invisible(.conn)
}
