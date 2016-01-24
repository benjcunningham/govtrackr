context("Constructing queries")

root <- "https://www.govtrack.us/api/v2/bill"

test_that("Empty queries are empty", {
  expect_equal(.create_query(root), paste0(root, "?"))
})

test_that("Ampersands are appended", {
  expect_equal(.add_amp(paste0(root, "?")),
               paste0(root, "?"))
  expect_equal(.add_amp(paste0(root, "?foo=bar")),
               paste0(root, "?foo=bar&"))
})

test_that("Filters are appended", {
  expect_equal(.create_query(root, list(foo = "bar")),
               paste0(root, "?foo=bar"))
  expect_equal(.create_query(root, list(foo = "bar", baz = "qux")),
               paste0(root, "?foo=bar&baz=qux"))
})

test_that("Sorts are appended", {
  expect_equal(.create_query(root, sort = c("foo")),
               paste0(root, "?sort=foo"))
  expect_equal(.create_query(root, sort = c("foo", "bar", "baz")),
               paste0(root, "?sort=foo|bar|baz"))
})

test_that("Limit is appended", {
  expect_equal(.create_query(root, limit = 300),
               paste0(root, "?limit=300"))
})

test_that("Offset is appended", {
  expect_equal(.create_query(root, offset = 0),
               paste0(root, "?offset=0"))
})


context("Validating arguments")

test_that("Bad filters are noted", {
  expect_equal(.bad_filters("bill", list(q = "foo", congress = 113)),
               c(q = FALSE, congress = FALSE))
  expect_equal(.bad_filters("bill", list(q = "foo", bar = "baz")),
               c(q = FALSE, bar = TRUE))
})