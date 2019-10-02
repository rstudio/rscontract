#' Close a connection
#'
#' @param host Host name of the connection. Optional, defaults to empty
#' @param type Type of connection. Optional, defaults to empty
#' @examples
#' rscontract_open(rscontract_spec())
#' rscontract_close("spec_host", "spec_type")
#'
#' @return
#'
#' Returns a NULL object. If using the RStudio IDE, it will attempt to close the
#' connection identified by the `host` and `type` arguments
#'
#' @export
rscontract_close <- function(host = "", type = "") {
  observer <- getOption("connectionObserver")
  if (is.null(observer)) {
    return(invisible(NULL))
  }
  observer$connectionClosed(host = host, type = type)
}
