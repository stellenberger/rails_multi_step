class CreateChildren < ActiveRecord::Migration[6.1]
  def change
    create_table :children do |t|
      t.string :first_name, null: false
      t.string :last_name,  null: false
      t.date :date_of_birth, null: false
      t.integer :gender

      t.timestamps
    end
  end
end
