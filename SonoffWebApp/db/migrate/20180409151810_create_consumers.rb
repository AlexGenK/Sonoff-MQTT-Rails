class CreateConsumers < ActiveRecord::Migration[5.1]
  def change
    create_table :consumers do |t|
      t.string :name
      t.string :phone

      t.timestamps
    end
  end
end
