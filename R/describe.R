#' Describe a Salesforce object
#'
#' Lists all metadata for a Salesforce object. For example, \code{describe} be
#' used to retrieve object fields, URLs, and child relationships.
#'
#' @param obj A character vector, name of Salesforce object
#'
#' @inheritParams query
#' @importFrom httr GET content
#' @export
describe <- function(.conn, obj) {
  stopifnot(is.character(obj), .conn$is_authorized())

  desc_response <- .conn$force_VERB('GET', paste0(.conn$base, '/services/data/v', .conn$version, '/sobjects/', obj, '/describe/'))

  description <- httr::content(desc_response)

  description
}
