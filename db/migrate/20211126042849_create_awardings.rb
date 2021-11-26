class CreateAwardings < ActiveRecord::Migration[6.1]
  def change
    create_table :awardings do |t|
      t.text :title
      t.references :user, foreign_key: true
      t.references :question, null: false, foreign_key: true

      t.timestamps
    end
  end
end
