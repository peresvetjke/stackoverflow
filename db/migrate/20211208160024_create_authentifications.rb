class CreateAuthentifications < ActiveRecord::Migration[6.1]
  def change
    create_table :authentifications do |t|
      t.references :user, null: false, foreign_key: true
      t.text :provider
      t.text :uid

      t.timestamps
    end
  end
end
