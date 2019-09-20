#' Refreshes a connection
#'
#' @param con Connection variable
#' @param hint Optional argument passed to the Contract
#'
#' @examples
#' con <- rscontract_open(rscontract_spec())
#' rscontract_update(con)
#' rscontract_close(con)
#' @export
rscontract_update <- function(con, hint = "") {
  UseMethod("rscontract_update")
}

#' @export
rscontract_update.rscontract_ide <- function(con, hint = "") {
  update_connection(type = con$type, host = con$host)
}

update_connection <- function(host, type, hint = "") {
  observer <- getOption("connectionObserver")
  if (is.null(observer)) {
    return(invisible(NULL))
  }
  observer$connectionUpdated(
    type = type,
    host = host,
    hint = hint
    )
}
