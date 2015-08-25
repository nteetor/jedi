#' Force API object
#'
#' This object holds the meta information for and represents a connection to the
#'
#' @importFrom magrittr %>% %<>% equals
#' @export
force_api <- function(base, version = NULL, username = NULL, password = NULL,
                      client_id = NULL, client_secret = NULL) {

  if (base %>% str_sub(end = -1) %>% equals('/'))
    base %<>% str_sub(1, -2)

  structure(
    list(
      base = base,
      version = version,
      client_id = client_id,
      client_secret = client_secret,
      username = username,
      password = password,
      access_token = NULL
    ),
    class = 'force_api'
  )
}

#' @keywords internal
#' @export
is.force_api <- function(x) {
  inherits(x, 'force_api')
}
