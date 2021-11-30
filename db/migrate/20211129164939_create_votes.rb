class CreateVotes < ActiveRecord::Migration[6.1]
  def change
    create_table :votes do |t|
      t.references :votable, polymorphic: true, null: false
      t.boolean :preference
      t.integer :author_id

      t.timestamps
    end
  end
end
