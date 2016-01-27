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
  expect_equal(.create_query(root, list(foo = c("bar", "baz"))),
               paste0(root, "?foo=bar|baz"))
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

test_that("Field selection is appended", {
  expect_equal(.create_query(root, select = c("foo")),
               paste0(root, "?fields=foo"))
  expect_equal(.create_query(root, select = c("foo", "bar")),
               paste0(root, "?fields=foo,bar"))
})


context("Validating arguments")

test_that("Bad filters are noted", {
  expect_equal(.bad_filters("bill", list(q = "foo", congress = 113)),
               c(q = FALSE, congress = FALSE))
  expect_equal(.bad_filters("bill", list(q = "foo", bar = "baz")),
               c(q = FALSE, bar = TRUE))
  expect_equal(.bad_filters("bill", list(congress__lte = 113)),
               c(congress = FALSE))
  expect_equal(.bad_filters("bill", list(foo__lte = 'bar')),
               c(foo = TRUE))
})


context("Fetching data sets")

test_that("Execution halts for bad resources", {
  expect_error(fetch_govtrack("foo"),
               "The resource `foo` does not exist at GovTrack.")
})

test_that("Execution halts for bad filters", {
  expect_error(fetch_govtrack("bill", filter = list(foo = "bar")),
               paste0("The following fields cannot be used for ",
                      "filtering: `foo`"))
  expect_error(fetch_govtrack("bill",
                              filter = list(foo = "bar", baz = "qux")),
               paste0("The following fields cannot be used for ",
                      "filtering: `foo`, `baz`"))
})

foo <- fetch_govtrack("bill", filter = list(congress = 112),
                      limit = 3)

test_that("Reasonable results are returned", {
  expect_true(is.data.frame(foo))
  expect_equal(nrow(foo), 3)
})
