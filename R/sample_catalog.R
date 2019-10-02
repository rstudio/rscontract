#' A example of how a connection hierarchy structure
#' @export
#'
#' @examples
#'
#' str(sample_catalog())
#'
#' @return
#'
#' A `list` object containing all of the needed information to open a very
#' simple connection contract
#'
sample_catalog <- function() {
  list(
    catalogs = list(
      name = "Database",
      type = "catalog",
      schemas = list(
        name = "Schema",
        type = "schema",
        tables = list(
          name = "table1",
          type = "table",
          fields = list(
            list(
              name = "field1",
              type = "chr"
            ),
            list(
              name = "field2",
              type = "int"
            )
          )
        )
      )
    )
  )
}
