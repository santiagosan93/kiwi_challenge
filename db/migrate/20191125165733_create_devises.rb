class CreateDevises < ActiveRecord::Migration[5.2]
  def change
    create_table :devises do |t|
      t.string :timestamp
      t.string :id
      t.string :type
      t.string :status
      t.integer :activity_change

      t.timestamps
    end
  end
end
