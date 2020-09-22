class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.string :title
      t.text :body
      t.integer :priority
      t.decimal :rating
      t.boolean :visible
      t.date :expiration_date
      t.time :expiration_time
      t.datetime :published_at
      t.json :metadata

      t.timestamps
    end
  end
end
