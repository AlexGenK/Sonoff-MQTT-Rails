class CreateMeters < ActiveRecord::Migration[5.1]
  def change
    create_table :meters do |t|
      t.string :name
      t.string :topic
      t.integer :k_trans
      t.integer :alarm_value
      t.boolean :alarm_om

      t.timestamps

      t.belongs_to :consumer, index: true
    end
  end
end
