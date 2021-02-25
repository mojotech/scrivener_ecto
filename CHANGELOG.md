# Changelog

## 2.8.0-dev

## 2.7.0 2020-11-23

* Don't pass `prefix` to repo when not provided

## 2.6.0 2020-10-21

* Remove elixir 1.11 warnings

## 2.5.0 2020-08-23

* Add `prefix` options (see
  [test](https://github.com/drewolson/scrivener_ecto/blob/8ef17361251aea9784d5b0402547327d90ca4184/test/scrivener/paginator/ecto/query_test.exs#L430)
  for usage)

## 2.4.0 2020-05-20

* Handle absolute distinct clauses in join pagination

## 2.3.0 2020-01-29

* Upgrade ecto to `~> 3.3`

## 2.2.0 2019-04-04

* Allow overflow page numbers when option is provided

## 2.1.1 2019-03-06

* Correctly handle `DISTINCT` queries when counting entries

## 2.1.0 2019-03-01

* Optimize `total_entries` for queries without group by clauses
* Allow directly specifying `offset`

## 2.0.0 2018-10-29

* Don't allow `page_number` to be greater than `total_pages`
* Support Ecto 3.0

## 1.3.0 2017-10-27

* Allow directly specifying `total_entries`

## 1.2.3 2017-08-26

* Handle complex group by statements in `total_entries`

## 1.2.2 2017-05-26

* Require Elixir `~> 1.3`

## 1.2.1 2017-03-29

* Return `total_pages` of `1` when there are no results

## 1.2.0 2017-03-27

* Supply `caller` when executing queries

## 1.1.4 2017-03-01

* Exclude `order_by` before building a subquery

## 1.1.3 2017-01-16

* Exclude `preload` and `select` before building a subquery

## 1.1.2 2017-01-16

* Use `subquery` to calculate `total_entries`

## 1.1.1 2017-01-07

* Remove Elixir 1.4.0 warnings

## 1.1.0 2016-12-21

* Support Ecto 2.1.x

## 1.0.3 2016-11-22

* Gracefully handle no result when counting records

## 1.0.2 2016-09-18

* Update postgrex dependency to 0.12.x

## 1.0.1 2016-08-18

* Include scrivener in applications to support releases

## 1.0.0 2016-06-21

* Initial release
