class CreateDevices < ActiveRecord::Migration[5.2]
  def change
    create_table :devices do |t|
      t.datetime :timestamp
      t.string :device_id
      t.string :device_type
      t.string :status

      t.timestamps
    end
  end
end
