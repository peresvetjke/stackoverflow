class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.text :body
      t.references :commentable, polymorphic: true, null: false
      t.integer :author_id
      
      t.timestamps
    end
  end
end
