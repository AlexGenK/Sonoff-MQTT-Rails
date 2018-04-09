class CreateEnergies < ActiveRecord::Migration[5.1]
  def change
    create_table :energies do |t|
      t.datetime :time
      t.float :total
      t.float :yesterday
      t.float :today
      t.integer :period
      t.integer :power
      t.float :factor
      t.integer :voltage
      t.float :current
      t.integer :alarm_value
      t.boolean :alarm_on

      t.timestamps

      t.belongs_to :meter, index: true
    end
  end
end
