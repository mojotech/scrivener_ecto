# Changelog

## 2.8.0-dev

## 2.7.0

* Don't pass `prefix` to repo when not provided

## 2.6.0

* Remove elixir 1.11 warnings

## 2.5.0

* Add `prefix` options (see
  [test](https://github.com/drewolson/scrivener_ecto/blob/8ef17361251aea9784d5b0402547327d90ca4184/test/scrivener/paginator/ecto/query_test.exs#L430)
  for usage)

## 2.4.0

* Handle absolute distinct clauses in join pagination

## 2.3.0

* Upgrade ecto to `~> 3.3`

## 2.2.0

* Allow overflow page numbers when option is provided

## 2.1.1

* Correctly handle `DISTINCT` queries when counting entries

## 2.1.0

* Optimize `total_entries` for queries without group by clauses
* Allow directly specifying `offset`

## 2.0.0

* Don't allow `page_number` to be greater than `total_pages`
* Support Ecto 3.0

## 1.3.0

* Allow directly specifying `total_entries`

## 1.2.3

* Handle complex group by statements in `total_entries`

## 1.2.2

* Require Elixir `~> 1.3`

## 1.2.1

* Return `total_pages` of `1` when there are no results

## 1.2.0

* Supply `caller` when executing queries

## 1.1.4

* Exclude `order_by` before building a subquery

## 1.1.3

* Exclude `preload` and `select` before building a subquery

## 1.1.2

* Use `subquery` to calculate `total_entries`

## 1.1.1

* Remove Elixir 1.4.0 warnings

## 1.1.0

* Support Ecto 2.1.x

## 1.0.3

* Gracefully handle no result when counting records

## 1.0.2

* Update postgrex dependency to 0.12.x

## 1.0.1

* Include scrivener in applications to support releases

## 1.0.0

* Initial release
