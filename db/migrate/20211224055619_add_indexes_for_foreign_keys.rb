class AddIndexesForForeignKeys < ActiveRecord::Migration[6.1]
  def change
    add_index :answers, :author_id
    add_index :questions, :author_id
    add_index :votes, :author_id
  end
end
