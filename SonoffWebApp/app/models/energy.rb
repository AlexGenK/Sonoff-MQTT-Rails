class Energy < ApplicationRecord
  belongs_to :meter

  # выборка данных и их представление в пригодном для графика виде
  def self.select_data_for_chart(query)
    pow_data = {}
    alarm_data = {}
    result = where(query)
    if result.present?
      result.each do |row|
        pow_data[row['time']] = row.period
        alarm_data[row['time']] = row.alarm_value
      end
      alarm_color = result.last.alarm_on? ? '#ff6666' : '#bfbfbf'
      return [{name: I18n.t('pow_chart.power'), data: pow_data}, {name: I18n.t('pow_chart.alarm'), data: alarm_data, color: alarm_color}]
    else
      return []
    end
  end
end
