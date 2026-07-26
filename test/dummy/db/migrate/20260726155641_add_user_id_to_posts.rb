# frozen_string_literal: true

# Adds a genuinely mixed-case column (quoted "userID", not the Rails-conventional "user_id")
# so specs can exercise Toller's case-insensitive param matching against a real camelCase
# column name, not just a camelCase declared parameter aliased to a snake_case column.
class AddUserIdToPosts < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :userID, :integer
  end
end
