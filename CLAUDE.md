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

# Run rspec across every appraisal
bundle exec appraisal rspec

# Run rspec across every appraisal with one runner
bundle exec appraisal -n 1 rspec
```

CI runs on GitHub Actions (`.github/workflows/ci.yml`): rspec, rubocop, yard-lint, and the full appraisal matrix. There is no Travis config anymore.

Note: `bundle exec appraisal rspec` (naming no specific appraisal) defaults to running 2 appraisals in parallel via the `appraisal2` gem. `test/dummy/config/database.yml` uses `database: ":memory:"` for the test env, so each appraisal subprocess gets its own isolated in-memory database — parallel runs no longer race on a shared file (`-n 1`/`APPRAISAL_JOBS=1` was needed when the test DB was a shared `db/test.sqlite3` file; it isn't anymore, though it's still a valid way to force serial runs if needed).

## Architecture

### Request flow

`Retriever.filter(collection, filter_params, sort_params, retrievals)` (`lib/toller/retriever.rb`) is the single entry point invoked by `Toller#retrieve`. It:

1. Builds `retrievals` — the flattened list of every `Filter` and `Sort` registered via `filter_on`/`sort_on` across the including class's ancestor chain (`self.class.ancestors.flat_map { |k| k.try(:_filters) }`). Filters and sorts share the same `_filters` array on the class.
2. Selects only the *active* retrievals: a `Filter` is active if its param key is present in `filter_params`, or if no filter params were sent at all and the filter is marked `default: true`. Sorts work the same way against `sort_params` (a comma-split array like `['-published_at', 'title']`). Matching is case-insensitive on both sides: `Toller#filter_params`/`#sort_params` downcase (and strip) the incoming request keys/tokens, and `Retriever` downcases `retrieval.parameter` the same way before comparing — so a request param's casing never has to match the declared `parameter`'s casing. This only affects *which* retrieval activates; the `field:` actually queried keeps its declared casing untouched (important for a genuinely camelCase DB column — see `filter_on :userID`/`sort_on :userID` in the dummy app).
3. Reduces over the active retrievals, calling `retrieval.apply!(collection, value)` on each and threading the returned relation forward — so each filter/sort chains a `.where`/`.order`/scope call onto the previous result.

### Filter vs Sort dispatch

`Filter#apply!` and `Sort#apply!` (`lib/toller/filter.rb`, `lib/toller/sort.rb`) both branch on `type == :scope`:

- `type: :scope` → delegates to `Filters::ScopeHandler` / `Sorts::ScopeHandler`, which call a named scope on the model (`collection.public_send(scope_name || field, value_or_direction)`). This is the escape hatch for anything not expressible as a plain `where`/`order`. Before calling, both handlers check `Toller::ScopeResolver.own_class_method?(collection.klass, scoped_name)` (`lib/toller/scope_resolver.rb`) rather than a bare `respond_to?` — it walks the model's singleton-class ancestors up to (excluding) `ActiveRecord::Base.singleton_class`, so a typo'd `scope_name:` that happens to collide with an inherited framework method (`delete_all`, `where`, `sum`, etc.) is treated as unresolved (logged + skipped) instead of being called.
- Any other type (`:string`, `:text`, `:integer`, `:boolean`, `:date`, `:datetime`, `:time`) → delegates to `Filters::ColumnHandler` (filters) or `Sorts::ColumnHandler` (sorts), which do a plain `collection.where(field => value)` / `collection.order(field => direction)`. Both first confirm `field` is a real column *and* that its actual column type (`collection.klass.columns_hash[field].type`) matches the declared `type:`, logging and skipping (rather than raising or silently misapplying a mismatched mutator) if either check fails.

### Mutators

`Filters::ColumnHandler` runs the raw param value through a per-type mutator before the `where` call (`lib/toller/filters/mutators/*.rb`): `boolean` maps `%w[1 t true y yes]` to `true` (case-insensitively). `date`, `datetime`, `time`, and `integer` all detect Ruby range syntax in the raw string (`..` for inclusive, `...` for exclusive) and convert it to a `Range` for range-based `where` queries — this logic is identical across the four, so it lives once in `Mutators::Common::Range` and each type module just does `extend Common::Range`. Sorts have no mutators — direction is always just `:asc`/`:desc` derived from a leading `-` in the sort param.

### Declaring filters/sorts

`filter_on(parameter, type:, **options)` / `sort_on(parameter, type:, **options)` (in `lib/toller.rb`'s `class_methods`) construct a `Filter`/`Sort` and push it onto `_filters`. Both constructors validate `type:` against `Toller::VALID_TYPES` (`%i[string text integer boolean date datetime time scope]`, defined in `lib/toller.rb`) and raise `ArgumentError` immediately if it's anything else — a typo like `type: :sting` fails loudly at declaration time rather than silently falling through with no mutator applied. Key options, all defaulted via `reverse_merge` in `Filter#initialize`/`Sort#initialize`:

- `field:` — the actual column/attribute to query; defaults to `parameter`. Lets you expose a different public param name than the underlying column (see `filter_on :post_title, type: :string, field: :title` in the dummy app).
- `scope_name:` — for `type: :scope`, the model scope to call; defaults to `parameter`.
- `default:` — if `true`, this filter/sort applies automatically when no filter/sort params were sent at all in the request.

### Customizing param keys

A controller can override `filter_param_key` / `sort_param_key` (default `:filters` / `:sort`) to change the query param names Toller reads from — see `ArticlesController` in the dummy app, which renames them to `:filtrations` / `:sorting`.

### Dummy app

`test/dummy` is a full minimal Rails app used only for running the request specs in `spec/requests/filter/*` and `spec/requests/sort/*`. `PostsController` there is the canonical example exercising every filter/sort type; `Post` (`test/dummy/app/models/post.rb`) defines the scopes those `type: :scope` filters/sorts call into. When adding a new filter/sort type or option, extend `PostsController`/`Post` and add a matching spec under `spec/requests/{filter,sort}/`.
