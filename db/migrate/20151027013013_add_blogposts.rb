class AddBlogposts < ActiveRecord::Migration
  def change
    create_table :blogposts do |t|
      t.string :title
      t.string :short_description
      t.text :body
      t.string :status
      t.integer :author_id
      t.datetime :published_at
      t.attachment :featured_image
    end
  end
end
