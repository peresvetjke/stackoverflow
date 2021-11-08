class CreateAnswers < ActiveRecord::Migration[6.1]
  def change
    create_table :answers do |t|
      t.references :question, null: false, foreign_key: true
      t.text :body
      t.integer :author_id

      t.timestamps
    end
  end
end
