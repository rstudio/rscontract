#' Populates the RStudio Connection viewer
#'
#' @param con Connection variable
#' @param connection_code Text of code to connect to the same source
#' @param host Name of Host of the connection
#' @param name Connection name
#' @param connection_id Unique ID of the connection for the current session
#'
#' @examples
#'
#' contract <- as_rscontract(rscontract_spec(name = "test"))
#' rscontract_view(contract)
#' rscontract_close(contract)
#' @export
rscontract_view <- function(con, connection_code = "", host = "",
                            name = "", connection_id = "") {
  UseMethod("rscontract_view")
}

#' @export
rscontract_view.rscontract_ide <- function(con, connection_code = "", host = "",
                                           name = "", connection_id = NULL) {

  con$connectCode <- first_non_empty(connection_code, con$connectCode)
  con$host <- first_non_empty(host, con$host)
  con$displayName <- first_non_empty(name, con$displayName)
  open_connection_contract(con)
}
