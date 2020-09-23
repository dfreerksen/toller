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

  # Sort - Default
  sort_on :default_sort_on_title, type: :scope, default: true

  # Sort - Integer
  sort_on :id, type: :integer

  # Sort - String
  sort_on :title, type: :string
  sort_on :post_title, type: :string, field: :title

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

  def index
    render json: filtrate(Post.all)
  end
end
