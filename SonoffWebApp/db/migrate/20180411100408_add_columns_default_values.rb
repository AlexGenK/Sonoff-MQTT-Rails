class AddColumnsDefaultValues < ActiveRecord::Migration[5.1]
  def change
  	change_column_default :meters, :alarm_value, 0
  	change_column_default :meters, :alarm_on, false
  	change_column_default :meters, :k_trans, 1
  	change_column_default :energies, :alarm_value, 0
  	change_column_default :energies, :alarm_on, false
  end
end
