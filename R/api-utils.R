#' Specify API version
#'
#' Adds a specifc version number to a \code{force_api} object or retrieves the
#' most recent API version.
#'
#' @param .conn A \code{force_api} object
#' @param v A character vector specifying the API version number or
#'   \code{"latest"}
#'
#' @details The format for the version number requires a trailing decimal point
#'   and zero are appended, for example "23.0".
#'
#'   If version is \code{"latest"} then the latest API version for the
#'   Salesforce instance specified by \code{.conn} is retrieved and assigned as
#'   the API version.
#'
#' @return An updated \code{force_api} object
#'
#' @importFrom magrittr %>% %$%
#' @importFrom stringr str_sub str_detect
#' @importFrom httr content
#' @export
use_version <- function(.conn, num) {
  if (!(.conn %>% is.force_api)) stop('connection must be a force_api object')
  if (!(num %>% is.character)) stop('version must be a character vector')
  if (!(num %>% str_detect('^\\d\\.0$|^latest$'))) stop('version number is incorrectly formatted')

  if (num == 'latest') {
    if (.conn$base %>% is.null) stop('cannot retrieve latest version number without a base URL')

    version_response <- httr::GET(paste0(.conn$base, '/services/data/'))

    httr::stop_for_status(version_response)

    .conn$version <- version_response %>%
      content %>% {
        .[[NROW(.)]]
      } %$%
      version

  } else {
    .conn$version <- num
  }

  invisible(.conn)
}

#' Specifiy Salesforce username
#'
#' Add a username to a \code{force_api} object. This username will be used to
#' authenticate the REST API connection and generate a session id.
#'
#' @inheritParams use_version
#' @param nm A character vector, the Salesforce username to connect with
#'
#' @return An updated \code{force_api} object
#'
#' @importFrom magrittr %>%
#' @export
username <- function(.conn, nm) {
  if (!(.conn %>% is.force_api)) stop('connection must be a force_api object')
  if (!(nm %>% is.character)) stop('username must be a character vector')

  .conn$username <- nm

  invisible(.conn)
}

#' @inheritParams use_version
#' @param pwd A character vector, the password concatenated with the security
#'   token for \code{username}
#'
#' @importFrom magrittr %>%
#' @export
password <- function(.conn, pwd) {
  if (!(.conn %>% is.force_api)) stop('connection must be a force_api object')
  if (!(pwd %>% is.character)) stop('password must be a character vector')

  .conn$password <- pwd

  invisible(.conn)
}

#' @inheritParams use_version
#'
#' @importFrom magrittr %>%
#' @export
client_id <- function(.conn, id) {
  if (!(.conn %>% is.force_api)) stop('connection must be a force_api object')
  if (!(id %>% is.character)) stop('client id must be a character vector')

  .conn$client_id <- id

  invisible(.conn)
}

#' @inheritParams use_version
#'
#' @importFrom magrittr %>%
#' @export
client_secret <- function(.conn, secret) {
  if (!(.conn %>% is.force_api)) stop('connection must be a force_api object')
  if (!(secret %>% is.character)) stop('client secret must be a character vector')

  .conn$client_secret <- secret

  invisible(.conn)
}
