#' A flexible API that can be converted to an RStudio Connection Contract
#' @param type Type of the connection.
#' @param host Name of the host
#' @param icon Path to the connection's icon. Defaults to NULL.
#' @param name The connection's name.
#' @param connect_script The text of the connection code.
#' @param disconnect_code Function to use to disconnect. Default to function(){}.
#' @param preview_code Function to run when the preview table icon is clicked on. Default to function(){}.
#' @param catalog_list Hierarchical list of the catalogs, schema, table/view and fields.
#' @param object_types Function that provides the structure of the connection.
#' The default function will work properly, it is going to be rare when it needs to be changed.
#' @param object_list Function to run to get the catalogs, schema, tables or views based what has been
#' expanded on. Defaults to NULL.
#' @param object_columns Funciton to run that pull the field information. Default to NULL
#' @param actions Additional buttons to add to the connection pane. Defaults to NULL.
#' @param connection_object The connection object. Default to NULL.
#'
#' @examples
#'
#' str(rscontract_spec())
#'
#' @export
rscontract_spec <- function(
                            connection_object = NULL,
                            type = "spec_type",
                            host = "spec_host",
                            icon = NULL,
                            name = "",
                            connect_script = "library(connections)\n[Place your code here]",
                            disconnect_code = "function() rscontract_close('spec_host', 'spec_type')", # Enchance to use connection_close()
                            preview_code = "function(){}",
                            catalog_list = "sample_catalog()",
                            object_types = "default_types()",
                            object_list = NULL,
                            object_columns = NULL,
                            actions = NULL) {
  a <- as.list(environment())
  structure(as.list(a), class = "rscontract_spec")
}


spec_list_objects <- function(x) {
  function(catalog = NULL, schema = NULL, spec = x, ...) {
    if (is.null(catalog)) {
      return(get_object(spec, "catalogs")$data)
    }
    if (is.null(schema)) {
      ctls <- get_object(spec, "catalogs", catalog)
      return(get_object(ctls, "schemas")$data)
    }
    ctls <- get_object(spec, "catalogs", catalog)
    schs <- get_object(ctls, "schemas", schema)
    return(get_object(schs, "tables")$data)
  }
}

spec_list_columns <- function(x) {
  function(catalog = NULL, schema = NULL, table = NULL, view = NULL, spec = x, ...) {
    table_object <- paste0(table, view)
    ctls <- get_object(spec, "catalogs", catalog)
    schs <- get_object(ctls, "schemas", schema)
    tbls <- get_object(schs, "tables", table_object)
    get_object(tbls, "fields")$data
  }
}

default_types <- function() {
  function() {
    list(catalog = list(
      contains =
        list(schema = list(
          contains =
            list(
              table = list(contains = "data"),
              view = list(contains = "data")
            )
        ))
    ))
  }
}

eval_list <- function(entry) {
  if (class(entry) == "list") {
    eval(parse(text = entry$code))
  } else {
    entry
  }
}

eval_char <- function(entry) {
  if (class(entry) == "character") {
    eval(parse(text = entry))
  } else {
    entry
  }
}

get_element <- function(obj, item, name = NULL, element = NULL) {
  item <- obj[[item]]
  if (flat_list(item)) {
    if (!is.null(name)) {
      ns <- as.logical(lapply(item, function(x) x$name == name))
      item <- item[ns][[1]]
    }
    if (!is.null(element)) {
      item <- lapply(item, function(x) x[[element]])
      if (length(item) == 1) item <- item[[1]]
      item <- item[as.logical(lapply(item, function(x) !is.null(x)))]
      item <- as.character(item)
    }
  } else {
    if (!is.null(name)) item <- item[item$name == name]
    if (!is.null(element)) item <- item[[element]]
  }
  item
}

item_object <- function(ctl, item = "") {
  r_code <- get_element(ctl, item, element = "code")

  i_code <- NULL
  if (length(r_code) > 0) {
    i_code <- lapply(r_code, function(x) eval(parse(text = x)))
    i_code <- i_code[[1]]
  }
  i_info <- get_element(ctl, item, element = "name")
  t_info <- get_element(ctl, item, element = "type")
  if (length(i_info) > 0) {
    if (class(i_info) == "character") i_info <- list(name = i_info, type = t_info)
    if (!flat_list(i_info)) i_info <- list(i_info)
  }
  i_tables <- lapply(
    c(i_info, i_code),
    function(x) data_frame(name = x$name, type = x$type)
  )
  i_table <- NULL
  for (j in seq_along(i_tables)) {
    i_table <- rbind(i_table, i_tables[[j]])
  }
  list(
    raw = get_element(ctl, item),
    data = i_table
  )
}

get_object <- function(base, item, name = "") {
  x <- item_object(base, item)
  if (name != "") {
    get_element(x, "raw", name = name)
  } else {
    x
  }
}

data_frame <- function(...) {
  data.frame(..., stringsAsFactors = FALSE)
}

as_data_frame <- function(...) {
  as.data.frame(..., stringsAsFactors = FALSE)
}

flat_list <- function(x) {
  l <- lapply(x, class)
  sl <- as.character(l)
  all(sl == "list")
}

first_non_empty <- function(...) {
  to_text <- c(...)
  not_empty <- which(to_text != "")
  if (length(not_empty) == 0) {
    return(NULL)
  }
  first_ne <- min(not_empty)
  to_text[first_ne]
}
