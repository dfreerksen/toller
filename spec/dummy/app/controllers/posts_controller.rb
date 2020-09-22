# frozen_string_literal: true

class PostsController < ApplicationController
  include Retrieve

  # Default
  sort_on :default_sort_on_title, type: :scope, default: true

  # String
  sort_on :title, type: :string
  sort_on :post_title, type: :string, field: :title
  sort_on :the_title, type: :scope
  sort_on :my_title, type: :scope, scope_name: :sort_on_title

  # Integer
  sort_on :id, type: :integer

  # Text
  sort_on :body, type: :text

  # Datetime
  sort_on :published_at, type: :datetime

  def index
    render json: filtrate(Post.all)
  end
end
