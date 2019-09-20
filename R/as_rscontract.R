#' Coerces object into an RStudio connection contract
#'
#' @param x Object that will be coerced
#'
#' @export
as_rscontract <- function(x) {
  UseMethod("as_rscontract")
}

#' @export
as_rscontract.rscontract_spec <- function(x) {
  rscontract_ide(
    connectionObject = eval_list(x$connection_object),
    type = eval_list(x$type),
    host = eval_list(x$host),
    displayName = eval_list(x$name),
    connectCode = eval_list(x$connect_script),
    disconnect = eval_char(x$disconnect_code),
    previewObject = eval_char(x$preview_code),
    listObjectTypes = eval_char(x$object_types),
    listObjects = ifelse(
      is.null(x$object_list),
      spec_list_objects(eval_char(x$catalog_list)),
      x$object_list
    ),
    listColumns = ifelse(
      is.null(x$object_columns),
      spec_list_columns(eval_char(x$catalog_list)),
      x$object_columns
    ),
    actions = x$actions
  )
}
