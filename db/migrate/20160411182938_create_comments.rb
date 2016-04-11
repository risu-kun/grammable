class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :message
      t.integer :user_id
      t.integer :gram_id

      t.timestamps null: false
    end

    add_index :comments, :user_id
    add_index :comments, :gram_id
  end
end
