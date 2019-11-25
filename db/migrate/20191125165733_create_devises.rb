class CreateDevises < ActiveRecord::Migration[5.2]
  def change
    create_table :devises do |t|
      t.string :timestamp
      t.string :device_id

      # Rename from type -> device_type to avoid the reserved word "type" problem
      t.string :device_type
      t.string :status

      t.timestamps
    end
  end
end
