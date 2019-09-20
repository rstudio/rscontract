
<!-- README.md is generated from README.Rmd. Please edit that file -->

# rscontract

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![Travis build
status](https://travis-ci.org/edgararuiz/rscontract.svg?branch=master)](https://travis-ci.org/edgararuiz/rscontract)
[![Codecov test
coverage](https://codecov.io/gh/edgararuiz/rscontract/branch/master/graph/badge.svg)](https://codecov.io/gh/edgararuiz/rscontract?branch=master)
<!-- badges: end -->

It is main goal is make it easier for other R packages or R projects to
integrate with the RStudio Connections Contract. It provides two levels
to integrate with the Connections pane:

1.  `rscontract_spec()` (higher) - A function that enables the user pass
    a hierarchical list object to describe the structure of the
    connection (catalog/schema/table). It is design in a way that the
    defaults open a very simple connection without changing any
    arguments. The idea is to allow you to easily iterate through small
    argument changes as you are learning how it works.
2.  `rscontract_ide()` (lower) - The arguments of this function matches
    one-to-one with the expected entries needed to open a Connection
    pane.

There are three functions that actually interact with the RStudio IDE:

1.  `rscontract_open()` - Opens the Connection pane
2.  `rscontract_update()` - Refreshes the Connections pane
3.  `rscontract_close()` - Closes the Connections pane

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("edgararuiz/rscontract")
```

## Basic example

The stock output of `rscontract_spec()` is loaded into a variable
`spec`. This way it is possible to display its contents before using it
to open a new connection.

``` r
library(rscontract)
```

``` r
library(rscontract)
spec <- rscontract_spec()
str(spec)
#> List of 13
#>  $ connection_object: NULL
#>  $ type             : chr "spec_type"
#>  $ host             : chr "spec_host"
#>  $ icon             : NULL
#>  $ name             : chr ""
#>  $ connect_script   : chr "library(connections)\n[Place your code here]"
#>  $ disconnect_code  : chr "function() rscontract_close('spec_host', 'spec_type')"
#>  $ preview_code     : chr "function(){}"
#>  $ catalog_list     : chr "sample_catalog()"
#>  $ object_types     : chr "default_types()"
#>  $ object_list      : NULL
#>  $ object_columns   : NULL
#>  $ actions          : NULL
#>  - attr(*, "class")= chr "rscontract_spec"
```

The connection can now be opened with `spec`.

``` r
rscontract_open(spec)
```

Notice above the values of the `type` and `host` entries inside `spec`.
Those are the two pieces of information needed by RStudio to identify
the connection that needs to be updated, or closed.

``` r
rscontract_update("spec_host", "spec_type")
```

After closing the connection, the content from the `connect_script`
variable can be seen.

``` r
rscontract_close("spec_host", "spec_type")
```

## Modified spec

``` r
library(rscontract)
spec <- rscontract_spec(
  type = "my_type",
  host = "my_host", 
  icon = system.file("images", "rstudio-icon.png", package = "rscontract"),
  name = "Modified Name",
  connect_script = "[This is my connection code]",
  disconnect_code = "function() rscontract_close('my_host', 'my_type')",
  preview_code = "function(catalog, schema, table, limit) data.frame(catalog, schema, table, limit)"
)
str(spec)
#> List of 13
#>  $ connection_object: NULL
#>  $ type             : chr "my_type"
#>  $ host             : chr "my_host"
#>  $ icon             : chr "/home/edgar/R/x86_64-pc-linux-gnu-library/3.6/rscontract/images/rstudio-icon.png"
#>  $ name             : chr "Modified Name"
#>  $ connect_script   : chr "[This is my connection code]"
#>  $ disconnect_code  : chr "function() rscontract_close('my_host', 'my_type')"
#>  $ preview_code     : chr "function(catalog, schema, table, limit) data.frame(catalog, schema, table, limit)"
#>  $ catalog_list     : chr "sample_catalog()"
#>  $ object_types     : chr "default_types()"
#>  $ object_list      : NULL
#>  $ object_columns   : NULL
#>  $ actions          : NULL
#>  - attr(*, "class")= chr "rscontract_spec"
```

``` r
rscontract_open(spec)
```

## Action buttons

``` r
spec$actions <- list(
  "Button 1" = list(
    icon = system.file("images", "rstudio-icon.png", package = "rscontract"),
    callback = function() print("hello")
  )
)

rscontract_open(spec)
```

``` r
spec_function <- function(x, message) {
  x$actions <- list(
  "Button 1" = list(
    icon = system.file("images", "rstudio-icon.png", package = "rscontract"),
    callback = function() print(message)
  ))
  x
}

rscontract_open(spec_function(spec, "test"))
```

``` r
rscontract_close("my_host", "my_type")
```

## Catalog structure

``` r
str(sample_catalog())
#> List of 1
#>  $ catalogs:List of 3
#>   ..$ name   : chr "Database"
#>   ..$ type   : chr "catalog"
#>   ..$ schemas:List of 3
#>   .. ..$ name  : chr "Schema"
#>   .. ..$ type  : chr "schema"
#>   .. ..$ tables:List of 3
#>   .. .. ..$ name  : chr "table1"
#>   .. .. ..$ type  : chr "table"
#>   .. .. ..$ fields:List of 2
#>   .. .. .. ..$ :List of 2
#>   .. .. .. .. ..$ name: chr "field1"
#>   .. .. .. .. ..$ type: chr "chr"
#>   .. .. .. ..$ :List of 2
#>   .. .. .. .. ..$ name: chr "field2"
#>   .. .. .. .. ..$ type: chr "int"
```

``` r
my_cat <- sample_catalog()
my_cat$catalogs$schemas$tables$fields[[3]] <- list(name = "test", type = "int")
spec <- rscontract_spec()
spec$catalog_list <- my_cat
str(spec)
#> List of 13
#>  $ connection_object: NULL
#>  $ type             : chr "spec_type"
#>  $ host             : chr "spec_host"
#>  $ icon             : NULL
#>  $ name             : chr ""
#>  $ connect_script   : chr "library(connections)\n[Place your code here]"
#>  $ disconnect_code  : chr "function() rscontract_close('spec_host', 'spec_type')"
#>  $ preview_code     : chr "function(){}"
#>  $ catalog_list     :List of 1
#>   ..$ catalogs:List of 3
#>   .. ..$ name   : chr "Database"
#>   .. ..$ type   : chr "catalog"
#>   .. ..$ schemas:List of 3
#>   .. .. ..$ name  : chr "Schema"
#>   .. .. ..$ type  : chr "schema"
#>   .. .. ..$ tables:List of 3
#>   .. .. .. ..$ name  : chr "table1"
#>   .. .. .. ..$ type  : chr "table"
#>   .. .. .. ..$ fields:List of 3
#>   .. .. .. .. ..$ :List of 2
#>   .. .. .. .. .. ..$ name: chr "field1"
#>   .. .. .. .. .. ..$ type: chr "chr"
#>   .. .. .. .. ..$ :List of 2
#>   .. .. .. .. .. ..$ name: chr "field2"
#>   .. .. .. .. .. ..$ type: chr "int"
#>   .. .. .. .. ..$ :List of 2
#>   .. .. .. .. .. ..$ name: chr "test"
#>   .. .. .. .. .. ..$ type: chr "int"
#>  $ object_types     : chr "default_types()"
#>  $ object_list      : NULL
#>  $ object_columns   : NULL
#>  $ actions          : NULL
#>  - attr(*, "class")= chr "rscontract_spec"
rscontract_open(spec)
```

## From a file

``` r
contract_file <- system.file("specs", "simple.yml", package = "rscontract")
contract <- yaml::read_yaml(contract_file)
str(contract)
#> List of 7
#>  $ name           : chr "displayName"
#>  $ type           : chr "type"
#>  $ host           : chr "host"
#>  $ connect_script : chr "Place connection code here"
#>  $ disconnect_code: chr "function() rscontract_close(\"host\", \"type\")"
#>  $ preview_code   : chr "function(table, view, ...) c(table, view)"
#>  $ catalog_list   :List of 1
#>   ..$ catalogs:List of 3
#>   .. ..$ name   : chr "my_catalog"
#>   .. ..$ type   : chr "catalog"
#>   .. ..$ schemas:List of 2
#>   .. .. ..$ :List of 3
#>   .. .. .. ..$ name  : chr "my_schema1"
#>   .. .. .. ..$ type  : chr "schema"
#>   .. .. .. ..$ tables:List of 2
#>   .. .. .. .. ..$ :List of 3
#>   .. .. .. .. .. ..$ name  : chr "my_table1"
#>   .. .. .. .. .. ..$ type  : chr "table"
#>   .. .. .. .. .. ..$ fields:List of 2
#>   .. .. .. .. .. .. ..$ :List of 2
#>   .. .. .. .. .. .. .. ..$ name: chr "field1"
#>   .. .. .. .. .. .. .. ..$ type: chr "nbr"
#>   .. .. .. .. .. .. ..$ :List of 2
#>   .. .. .. .. .. .. .. ..$ name: chr "field2"
#>   .. .. .. .. .. .. .. ..$ type: chr "chr"
#>   .. .. .. .. ..$ :List of 3
#>   .. .. .. .. .. ..$ name  : chr "my_view1"
#>   .. .. .. .. .. ..$ type  : chr "view"
#>   .. .. .. .. .. ..$ fields:List of 2
#>   .. .. .. .. .. .. ..$ :List of 2
#>   .. .. .. .. .. .. .. ..$ name: chr "field3"
#>   .. .. .. .. .. .. .. ..$ type: chr "nbr"
#>   .. .. .. .. .. .. ..$ :List of 2
#>   .. .. .. .. .. .. .. ..$ name: chr "field4"
#>   .. .. .. .. .. .. .. ..$ type: chr "chr"
#>   .. .. ..$ :List of 3
#>   .. .. .. ..$ name  : chr "my_schema2"
#>   .. .. .. ..$ type  : chr "schema"
#>   .. .. .. ..$ tables:List of 2
#>   .. .. .. .. ..$ :List of 3
#>   .. .. .. .. .. ..$ name  : chr "my_table4"
#>   .. .. .. .. .. ..$ type  : chr "table"
#>   .. .. .. .. .. ..$ fields:List of 2
#>   .. .. .. .. .. .. ..$ :List of 2
#>   .. .. .. .. .. .. .. ..$ name: chr "field5"
#>   .. .. .. .. .. .. .. ..$ type: chr "nbr"
#>   .. .. .. .. .. .. ..$ :List of 2
#>   .. .. .. .. .. .. .. ..$ name: chr "field6"
#>   .. .. .. .. .. .. .. ..$ type: chr "chr"
#>   .. .. .. .. ..$ :List of 3
#>   .. .. .. .. .. ..$ name  : chr "my_view2"
#>   .. .. .. .. .. ..$ type  : chr "view"
#>   .. .. .. .. .. ..$ fields:List of 2
#>   .. .. .. .. .. .. ..$ :List of 2
#>   .. .. .. .. .. .. .. ..$ name: chr "field7"
#>   .. .. .. .. .. .. .. ..$ type: chr "nbr"
#>   .. .. .. .. .. .. ..$ :List of 2
#>   .. .. .. .. .. .. .. ..$ name: chr "field8"
#>   .. .. .. .. .. .. .. ..$ type: chr "chr"
```

``` r
spec <- as_rscontract(contract)
rscontract_open(spec)
```

``` r
#contract_file <- system.file("specs", "full.yml", package = "rscontract")
contract_file <- "inst/specs/full.yml"
contract <- yaml::read_yaml(contract_file)
str(contract)
#> List of 7
#>  $ name           :List of 1
#>   ..$ code: chr "toupper(\"my_title\")"
#>  $ type           :List of 1
#>   ..$ code: chr "tolower(\"TYPE\")"
#>  $ host           : chr "host"
#>  $ connect_script : chr "Place connection code here"
#>  $ disconnect_code: chr "function() rscontract_close(\"host\", \"type\")"
#>  $ preview_code   : chr "function(table, view, ...) c(table, view)"
#>  $ catalog_list   :List of 1
#>   ..$ catalogs:List of 3
#>   .. ..$ name   : chr "my_catalog"
#>   .. ..$ type   : chr "catalog"
#>   .. ..$ schemas:List of 1
#>   .. .. ..$ :List of 3
#>   .. .. .. ..$ name  : chr "my_schema1"
#>   .. .. .. ..$ type  : chr "schema"
#>   .. .. .. ..$ tables:List of 1
#>   .. .. .. .. ..$ :List of 3
#>   .. .. .. .. .. ..$ name  : chr "my_view1"
#>   .. .. .. .. .. ..$ type  : chr "view"
#>   .. .. .. .. .. ..$ fields:List of 1
#>   .. .. .. .. .. .. ..$ code: chr "list(list(name = \"ext_function\", type = \"int\"))"
```

``` r
my_fields <- function() list(name = "ext_function", type = "int")
spec <- as_rscontract(contract)
rscontract_open(spec)
```
