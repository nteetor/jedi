#' Generate an OAuth 2.0 access token
#'
#' Uses the information stored in a \code{force_api} object to request an access
#' token from Salesforce.
#'
#' @importFrom magrittr %>% %$%
#' @importFrom httr content
#' @export
authorize <- function(.conn) {

  auth_response <- httr::POST(
    'https://login.salesforce.com/services/oauth2/token',
    body = list(
      grant_type = 'password',
      client_id = .conn$client_id,
      client_secret = .conn$client_secret,
      username = .conn$username,
      password = .conn$password
    )
  )

  httr::stop_for_status(auth_response)

  .conn$access_token <- auth_response %>%
    content %$%
    access_token

  invisible(.conn)
}
