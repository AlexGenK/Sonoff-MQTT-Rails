class Energy < ApplicationRecord
  belongs_to :meter

  # выборка данных и их представление в пригодном для графика виде
  def self.select_data_for_chart(query, by_hour)
    pow_data = {}
    alarm_data = {}
    result = by_hour ? where(query).group_by_hour(:created_at).sum(:period) : where(query)
    if result.present?
      result.each do |row|
        if by_hour
          pow_data[row[0]] = row[1]
          alarm_data[row[0]] = 0
        else
          pow_data[row['time']] = row.period
          alarm_data[row['time']] = row.alarm_value
        end
      end
      if by_hour
        alarm_color = '#bfbfbf'
      else
        alarm_color = (result.last.alarm_on? && !by_hour) ? '#ff6666' : '#bfbfbf'
      end
      return [{name: I18n.t('pow_chart.power'), data: pow_data}, {name: I18n.t('pow_chart.alarm'), data: alarm_data, color: alarm_color}]
    else
      return []
    end
  end
end
