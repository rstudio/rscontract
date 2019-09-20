#' Close a connection
#'
#' @param con Connection variable
#' @param host Host name of the connection. Optional, defaults to empty
#' @param type Type of connection. Optional, defaults to empty
#' @param leave_open Should the connection be left open. Defaults to FALSE
#' @examples
#' con <- rscontract_open(rscontract_spec())
#' rscontract_close(con)
#' @export
rscontract_close <- function(con, host = "", type = "",
                             leave_open = FALSE) {
  UseMethod("rscontract_close")
}

#' @export
rscontract_close.rscontract_ide <- function(con, host = "", type = "",
                                            leave_open = FALSE) {
  host <- first_non_empty(host, con$host)
  type <- first_non_empty(type, con$type)
  close_connection(type = type, host = host)
}

close_connection <- function(host, type) {
  observer <- getOption("connectionObserver")
  if (is.null(observer)) {
    return(invisible(NULL))
  }
  observer$connectionClosed(type = type, host = host)
}
