#' Force.com API abstraction object
#'
#' This object is an abstract representation of the Force.com REST API. The
#' object holds meta information necessary to use REST API resources and
#' provides helpful internal function. These functions are in turn used to
#' create S3-stylized functions which are exposed to the programmer.
#'
#' Create a new \code{force_api} object with the \code{connect_to} function.
#'
#' @section Methods:
#' \itemize{
#'  \item TODO
#'  \item TODO
#' }
#'
#' @keywords internal
#' @format An R6Class object.
#' @importFrom R6 R6Class
#' @importFrom magrittr %>% %<>% equals
#' @export
force_api <- R6::R6Class(
  'force_api',
  public = list(
    base = NULL,
    version = NULL,
    username = NULL,
    password = NULL,
    client_id = NULL,
    client_secret = NULL,
    access_token = NULL,

    initialize = function(url, ...) {
      stopifnot(is.character(url))

      args <- list(...)


      self$username <- args$username
      self$password <- args$password
      self$client_id <- args$client_id
      self$client_secret <- args$client_secret

      if (str_sub(url, end = -1) == '/') {
        self$base <- str_sub(url, 1, -2)
      } else {
        self$base <- url
      }

      if (!is.null(args$version)) {
        self$version <- args$version

      } else {
        version_response <- httr::GET(paste0(self$base, '/services/data/'))

        check_salesforce_response(version_response)

        self$version <- version_response %>%
          content %>% {
            .[[NROW(.)]]
          } %$%
          version
      }

      invisible(self)
    },
    is_authorized = function() {
      !is.null(self$access_token)
    },
    authorize_connection = function() {
      auth_response <- httr::POST(
        'https://login.salesforce.com/services/oauth2/token',
        body = list(
          grant_type = 'password',
          client_id = self$client_id,
          client_secret = self$client_secret,
          username = self$username,
          password = self$password
        )
      )

      check_salesforce_response(auth_response)

      self$access_token <- httr::content(auth_response)$access_token

      invisible(self)
    },
    force_VERB = function(verb, url, ...) {
      resp <- httr::VERB(verb, url, ..., httr::add_headers(Authorization = paste('Bearer', self$access_token)))

      check_salesforce_response(resp)

      resp
    }
  )
)

#' @keywords internal
#' @export
is.force_api <- function(x) {
  inherits(x, 'force_api')
}
