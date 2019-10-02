#' Coerces object into an RStudio connection contract
#'
#' @param x Object that will be coerced
#'
#' @examples
#'
#' as_rscontract(sample_catalog())
#'
#' @return
#'
#' An `rs_contract_ide` class object
#'
#' @export
as_rscontract <- function(x) {
  UseMethod("as_rscontract")
}

#' @export
as_rscontract.rscontract_spec <- function(x) {
  to_contract(x)
}

#' @export
as_rscontract.list <- function(x) {
  spec <- rscontract_spec()
  names_x <- names(x)
  for (i in seq_along(x)) {
    item <- names_x[[i]]
    spec[[item]] <- x[[item]]
  }
  to_contract(spec)
}

to_contract <- function(x) {
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
    actions = x$actions,
    icon = x$icon
  )
}
