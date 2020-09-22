# frozen_string_literal: true

class PostsController < ApplicationController
  include Retrieve

  def index
    render json: filtrate(Post.all)
  end
end
