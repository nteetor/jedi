force_api <- function(base, version) {
  structure(
    list(
      base = base,
      version = version
    ),
    class = 'force_api'
  )
}

is.force_api <- . %>% inherits('force_api')
