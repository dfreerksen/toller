# frozen_string_literal: true

class Post < ApplicationRecord
  # A direction param is still sent with default sorting whether it is used or not. Default sort order is `:asc`. You
  # can either use that value or avoid the parameter an do your own thing as we are doing below
  scope :default_sort_on_title, (lambda do |_direction|
    order(title: :asc)
  end)
  scope :the_title, ->(direction) { order(title: direction) }
  scope :sort_on_title, ->(direction) { order(title: direction) }
end
