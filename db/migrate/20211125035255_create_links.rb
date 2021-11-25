class CreateLinks < ActiveRecord::Migration[6.1]
  def change
    create_table :links do |t|
      t.text :title
      t.text :url
      t.references :linkable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
