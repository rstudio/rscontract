#' Refreshes a connection
#'
#' @param host Connection's Host name
#' @param type The connection's type
#' @param hint Optional argument passed to the Contract
#'
#' @examples
#' con <- rscontract_open(rscontract_spec())
#' rscontract_update(con)
#' rscontract_close(con)
#'
#' @return
#'
#' Returns a NULL object. If using the RStudio IDE, it will attempt to refresh the
#' connection identified by the `host` and `type` arguments
#'
#' @export
rscontract_update <- function(host = "", type = "", hint = "") {
  observer <- getOption("connectionObserver")
  if (is.null(observer)) {
    return(invisible(NULL))
  }
  observer$connectionUpdated(type = type, host = host, hint = hint)
}
