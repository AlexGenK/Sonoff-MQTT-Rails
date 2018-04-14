class Energy < ApplicationRecord
  belongs_to :meter

  # выборка данных и их представление в пригодном для графика виде
  def self.select_data_for_chart(query)
    pow_data = {}
    alarm_data = {}
    result = where(query)
    result.each do |row|
      pow_data[row['time']] = row.period
      alarm_data[row['time']] = row.alarm_value
    end
    alarm_color = last.alarm_on? ? '#ff6666' : '#bfbfbf'
    return [{name: 'Power', data: pow_data}, {name: 'Alarm lewel', data: alarm_data, color: alarm_color}]
  end
end
