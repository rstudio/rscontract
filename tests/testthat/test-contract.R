context("rscontract")

test_that("Basic functions work", {
  con <- rscontract_open(rscontract_spec(name = "test"))
  expect_silent(rscontract_open(rscontract_spec()))
  expect_silent(rscontract_update("spec_host", "spec_type"))
  expect_silent(rscontract_close("spec_host", "spec_type"))
})

test_that("Class functions return expected object types", {
  con <- as_rscontract(rscontract_spec(name = "test"))
  expect_is(con$listObjects(), "data.frame")
  expect_is(con$listObjects(catalog = "Database"), "data.frame")
  expect_is(con$listObjects(catalog = "Database", schema = "Schema"), "data.frame")
  expect_is(con$listColumns(catalog = "Database", schema = "Schema", table = "table1"), "data.frame")
  expect_is(con$listObjectTypes(), "list")
})

test_that("List coercion return expected object types", {
  test_list <- list(name = "testlist")
  con <- as_rscontract(test_list)
  expect_is(con$listObjects(), "data.frame")
  expect_is(con$listObjects(catalog = "Database"), "data.frame")
  expect_is(con$listObjects(catalog = "Database", schema = "Schema"), "data.frame")
  expect_is(con$listColumns(catalog = "Database", schema = "Schema", table = "table1"), "data.frame")
  expect_is(con$listObjectTypes(), "list")
})


test_that("Support functions work", {
  expect_is(as_data_frame(x = "a"), "data.frame")
  expect_is(first_non_empty("", ""), "NULL")
  expect_equal(first_non_empty("", "", "a"), "a")
})

test_that("Other contract functions", {
  expect_silent(eval_list(list(code = "x <-  10")))
  expect_silent(eval_char("x <-  10"))
  expect_silent(eval_char(list()))
})
#
test_that("get_element() function", {
  test_obj <- list(test = list(name = "test"))
  expect_equal(
    get_element(test_obj, "test", name = "test"),
    list(name = "test")
  )
  test_obj <- list(test = list(list(name = "test")), list(name = "test2"))
  expect_equal(
    get_element(test_obj, "test", name = "test"),
    list(name = "test")
  )
})
