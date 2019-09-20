#' Mirrors the RStudio IDE connection contract arguments
#' @param type Type of the connection.
#' @param host Name of the host
#' @param icon Path to the connection's icon. Defaults to NULL.
#' @param displayName The connection's name.
#' @param connectCode The text of the connection code.
#' @param disconnect Function to use to disconnect. Default to function(){}.
#' @param previewObject Function to run when the preview table icon is clicked on. Default to function(){}.
#' @param listObjectTypes Function that provides the structure of the connection.
#' The default function will work properly, it is going to be rare when it needs to be changed.
#' @param listObjects Function to run to get the catalogs, schema, tables or views based what has been
#' expanded on. Default to function(){}.
#' @param listColumns Funciton to run that pull the field information. Default to function(){}.
#' @param actions Additional buttons to add to the connection pane. Defaults to NULL.
#' @param connectionObject The connection object. Default to NULL.
#' @export
rscontract_ide <- function(
  connectionObject = NULL,
  type = "",
  host = "",
  icon = NULL,
  displayName = "",
  connectCode = "",
  disconnect = function() {},
  previewObject = function() {},
  listObjectTypes = default_types(),
  listObjects = function() {},
  listColumns = function() {},
  actions = NULL) {
  a <- as.list(environment())
  structure(as.list(a), class = "rscontract_ide")
}
