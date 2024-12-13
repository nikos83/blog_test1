class AddPostTouser < ActiveRecord::Migration[8.0]
  def change
    add_reference :posts, :user, null: false, foreign_key: true, default: 1
  end
end
