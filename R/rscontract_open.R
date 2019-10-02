#' Opens a connection
#'
#' @param x An rscontract_ide object, or an object coercible to an rscontract_ide
#'
#' @examples
#' rscontract_open(rscontract_spec())
#' rscontract_close("spec_host", "spec_type")
#'
#' @return
#'
#' Returns a NULL object.  If using the RStudio IDE, it will attempt to open the
#' connection, and set the identification using the `host` and `type` argument
#' values
#'
#' @export
rscontract_open <- function(x) {
  UseMethod("rscontract_open")
}

#' @export
rscontract_open.rscontract_ide <- function(x) {
  open_connection_contract(x)
}

#' @export
rscontract_open.rscontract_spec <- function(x) {
  rs_contract <- as_rscontract(x)
  rscontract_open(rs_contract)
}

open_connection_contract <- function(spec) {
  observer <- getOption("connectionObserver")
  if (is.null(observer)) {
    return(invisible(NULL))
  }
  connection_opened <- function(...) observer$connectionOpened(...)
  do.call("connection_opened", spec)
}
