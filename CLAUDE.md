# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

Toller is a Rails engine/gem that adds URL-query-param-based filtering and sorting to controllers. A controller includes `Toller` and declares `filter_on` / `sort_on` directives; `retrieve(collection)` then applies whichever filters/sorts are active for the current request to an ActiveRecord relation.

Detailed usage docs live in the GitHub wiki, not in this repo — the README only has a brief overview.

## Commands

Run against the dummy Rails app under `test/dummy`.

```bash
# Full test run (drops/creates/loads the test db, then runs rspec)
bin/test

# Run a single spec file directly (db must already be set up via bin/test once)
RAILS_ENV=test bundle exec rspec spec/requests/filter/boolean_spec.rb

# Run a single example by line number
RAILS_ENV=test bundle exec rspec spec/requests/sort/scope_spec.rb:12

# Lint
bundle exec rubocop

# Test across supported Rails versions (after `bundle exec appraisal install`)
bundle exec appraisal rails-6-0 bin/test
bundle exec appraisal rails-6-1 bin/test

# Run rspec across every appraisal — must pass -n 1
bundle exec appraisal -n 1 rspec

# Travis simulation (requires `gem install wwtd`)
wwtd
```

Note: the `Appraisals` file currently declares `rails-8-1` down through `rails-6-0` appraisals, but `.travis.yml` still references the old `rails_5.gemfile`/`rails_6.gemfile` — these are out of sync.

Note: `bundle exec appraisal rspec` (naming no specific appraisal) defaults to running 2 appraisals in parallel via the `appraisal2` gem. Every appraisal points at the same `test/dummy/db/test.sqlite3` file, so parallel runs race on writes and intermittently fail with `SQLite3::BusyException: database is locked`. Always pass `-n 1` (or set `APPRAISAL_JOBS=1`) when invoking `appraisal` without a specific appraisal name.

## Architecture

### Request flow

`Retriever.filter(collection, filter_params, sort_params, retrievals)` (`lib/toller/retriever.rb`) is the single entry point invoked by `Toller#retrieve`. It:

1. Builds `retrievals` — the flattened list of every `Filter` and `Sort` registered via `filter_on`/`sort_on` across the including class's ancestor chain (`self.class.ancestors.flat_map { |k| k.try(:_filters) }`). Filters and sorts share the same `_filters` array on the class.
2. Selects only the *active* retrievals: a `Filter` is active if its param key is present in `filter_params`, or if no filter params were sent at all and the filter is marked `default: true`. Sorts work the same way against `sort_params` (a comma-split array like `['-published_at', 'title']`).
3. Reduces over the active retrievals, calling `retrieval.apply!(collection, value)` on each and threading the returned relation forward — so each filter/sort chains a `.where`/`.order`/scope call onto the previous result.

### Filter vs Sort dispatch

`Filter#apply!` and `Sort#apply!` (`lib/toller/filter.rb`, `lib/toller/sort.rb`) both branch on `type == :scope`:

- `type: :scope` → delegates to `Filters::ScopeHandler` / `Sorts::ScopeHandler`, which call a named scope on the model (`collection.public_send(scope_name || field, value_or_direction)`). This is the escape hatch for anything not expressible as a plain `where`/`order`.
- Any other type (`:string`, `:text`, `:integer`, `:boolean`, `:date`, `:datetime`, `:time`) → delegates to `Filters::WhereHandler` (filters) or `Sorts::OrderHandler` (sorts), which do a plain `collection.where(field => value)` / `collection.order(field => direction)`.

### Mutators

`Filters::WhereHandler` runs the raw param value through a per-type mutator before the `where` call (`lib/toller/filters/mutators/*.rb`): `boolean` maps `%w[1 t true y yes]` to `true`; `integer`/`time`/`datetime` coerce the string; `date` additionally detects Ruby range syntax in the raw string (`..` / `...`) and converts it to a `Range` for range-based `where` queries. Sorts have no mutators — direction is always just `:asc`/`:desc` derived from a leading `-` in the sort param.

### Declaring filters/sorts

`filter_on(parameter, type:, **options)` / `sort_on(parameter, type:, **options)` (in `lib/toller.rb`'s `class_methods`) construct a `Filter`/`Sort` and push it onto `_filters`. Key options, all defaulted via `reverse_merge` in `Filter#initialize`/`Sort#initialize`:

- `field:` — the actual column/attribute to query; defaults to `parameter`. Lets you expose a different public param name than the underlying column (see `filter_on :post_title, type: :string, field: :title` in the dummy app).
- `scope_name:` — for `type: :scope`, the model scope to call; defaults to `parameter`.
- `default:` — if `true`, this filter/sort applies automatically when no filter/sort params were sent at all in the request.

### Customizing param keys

A controller can override `filter_param_key` / `sort_param_key` (default `:filters` / `:sort`) to change the query param names Toller reads from — see `ArticlesController` in the dummy app, which renames them to `:filtrations` / `:sorting`.

### Dummy app

`test/dummy` is a full minimal Rails app used only for running the request specs in `spec/requests/filter/*` and `spec/requests/sort/*`. `PostsController` there is the canonical example exercising every filter/sort type; `Post` (`test/dummy/app/models/post.rb`) defines the scopes those `type: :scope` filters/sorts call into. When adding a new filter/sort type or option, extend `PostsController`/`Post` and add a matching spec under `spec/requests/{filter,sort}/`.
