#' Opens a connection
#'
#' @param ... Passes arguments to wrapped connection function
#' @param open_pane Signals for the RStudio Connections pane to open. Defaults to TRUE.
#'
#' @examples
#' con <- rscontract_open(rscontract_spec())
#' rscontract_close(con)
#' @export
rscontract_open <- function(..., open_pane = TRUE) {
  UseMethod("rscontract_open")
}

#' @export
rscontract_open.rscontract_ide <- function(con, ..., open_pane = TRUE) {
  open_connection_contract(con)
  con
}

#' @export
rscontract_open.rscontract_spec <- function(con, ..., open_pane = TRUE) {
  rs_contract <- as_rscontract(con)
  rscontract_open(rs_contract)
  rs_contract
}
