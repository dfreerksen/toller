# frozen_string_literal: true

class PostsController < ApplicationController
  include Toller

  # Sort - Default
  filter_on :default_filter_on_published_at, type: :scope, default: true

  # Filter - Integer
  filter_on :priority, type: :integer

  # Filter - Boolean
  filter_on :visible, type: :boolean

  # Filter - String
  filter_on :title, type: :string
  filter_on :post_title, type: :string, field: :title
  filter_on :postTitle, type: :string, field: :title

  # Filter - Text
  filter_on :body, type: :text

  # Filter - Datetime
  filter_on :published_at, type: :datetime

  # Filter - Date
  filter_on :expiration_date, type: :date

  # Filter - Time
  filter_on :expiration_time, type: :time

  # Filter - Scope
  filter_on :body_contains, type: :scope, scope_name: :filter_on_body_contains

  # Filter - Unresolvable column/scope (exercises Toller's missing target handling)
  filter_on :bogus_column, type: :string, field: :nonexistent_column
  filter_on :bogus_scope, type: :scope, scope_name: :nonexistent_scope

  # Filter - declared type doesn't match the actual column type (exercises Toller's
  # protection against silently applying a mismatched mutator)
  filter_on :mismatched_type, type: :integer, field: :title

  # Filter - scope_name colliding with a real ActiveRecord class method (exercises Toller's
  # protection against public_send-ing an inherited framework method instead of an own scope)
  filter_on :dangerous_scope_collision, type: :scope, scope_name: :delete_all

  # Sort - Default
  sort_on :default_sort_on_title, type: :scope, default: true

  # Sort - Integer
  sort_on :id, type: :integer

  # Sort - String
  sort_on :title, type: :string
  sort_on :post_title, type: :string, field: :title
  sort_on :postTitle, type: :string, field: :title

  # Sort - Text
  sort_on :body, type: :text

  # Sort - Datetime
  sort_on :published_at, type: :datetime

  # Sort - Date
  sort_on :expiration_date, type: :date

  # Sort - Time
  sort_on :expiration_time, type: :time

  # Sort - Scope
  sort_on :the_title, type: :scope
  sort_on :my_title, type: :scope, scope_name: :sort_on_title

  # Sort - Unresolvable column/scope (exercises Toller's missing target handling)
  sort_on :bogus_column, type: :string, field: :nonexistent_column
  sort_on :bogus_scope, type: :scope, scope_name: :nonexistent_scope

  # Sort - declared type doesn't match the actual column type (exercises Toller's
  # protection against silently applying a mismatched mutator)
  sort_on :mismatched_type, type: :integer, field: :title

  # Sort - scope_name colliding with a real ActiveRecord class method (exercises Toller's
  # protection against public_send-ing an inherited framework method instead of an own scope)
  sort_on :dangerous_scope_collision, type: :scope, scope_name: :delete_all

  def index
    render json: retrieve(Post.all)
  end
end
