# frozen_string_literal: true

class ArticlesController < ApplicationController
  include Toller

  # Filter - String
  filter_on :title, type: :string

  # Sort - String
  sort_on :title, type: :string

  def index
    render json: retrieve(Post.all)
  end

  def filter_param_key
    :filtrations
  end

  def sort_param_key
    :sorting
  end
end
