# frozen_string_literal: true

class Post < ApplicationRecord
  scope :default_filter_on_published_at, (lambda do |_value|
    where(deleted_at: nil)
  end)
  scope :filter_on_body_contains, ->(value) { where('body like ?', "%#{value}%") }

  # A direction param is still sent with default sorting whether it is used or not. Default sort order is `:asc`. You
  # can either use that value or avoid the parameter and do your own thing as we are doing below
  scope :default_sort_on_title, (lambda do |_direction|
    order(title: :asc)
  end)
  scope :the_title, ->(direction) { order(title: direction) }
  scope :sort_on_title, ->(direction) { order(title: direction) }
end
