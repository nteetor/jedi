#' Specify API version
#'
#' Adds a specifc version number to a \code{force_api} object or retrieves the
#' most recent API version.
#'
#' @param .conn A \code{force_api} object
#' @param vrsn A character vector specifying the API version number or
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
#' @importFrom httr GET content add_headers
#' @export
use_version <- function(.conn, vrsn) {
  stopifnot(is.force_api(.conn), is.character(vrsn), str_detect(vrsn, '^\\d+\\.0$'))

  .conn$version <- vrsn

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
  stopifnot(is.force_api(.conn), is.character(nm))

  .conn$username <- nm

  invisible(.conn)
}

#' Set password
#'
#' @inheritParams use_version
#' @param psswd A character vector, the password concatenated with the security
#'   token for \code{username}
#'
#' @importFrom magrittr %>%
#' @export
password <- function(.conn, psswd) {
  stopifnot(is.force_api(.conn), is.character(psswd))

  .conn$password <- psswd

  invisible(.conn)
}

#' Set client ID
#'
#' @inheritParams use_version
#'
#' @importFrom magrittr %>%
#' @export
client_id <- function(.conn, id) {
  stopifnot(is.force_api(.conn), is.character(id))

  .conn$client_id <- id

  invisible(.conn)
}

#' Set client secret
#'
#' @inheritParams use_version
#'
#' @importFrom magrittr %>%
#' @export
client_secret <- function(.conn, secret) {
  stopifnot(is.force_api(.conn), is.character(secret))

  .conn$client_secret <- secret

  invisible(.conn)
}
