require 'mqtt'
require 'pg'
require './helpers/sender'
require './helpers/colorizer'
require './helpers/electricalparams'

# чтение параметров подкючения БД
connect = PG.connect(dbname: 'SonoffWebApp_development',
                     user: 'SonoffWebApp',
                     password: ENV['SONOFFWEBAPP_DATABASE_PASSWORD'])

# создание канала отправки сообщения
sender = Sender.new(send_to: ENV['POW_SMS_TEL'])
puts "Let's go!"
# устанавливаем соединение с MQTT брокером
MQTT::Client.connect(ENV['POW_MQTT_HOST'], ENV['POW_MQTT_PORT'].to_i) do |c|
  # читаем сообщения от MQTT брокера
  c.get(ENV['POW_MQTT_SENSORS_TOPIC']) do |topic, message|
    puts '--------PG--------'
    puts "#{topic}: #{message}"

    # получение текущих параметров электросети
    line_params = ElectricalParams.new(topic, message)

    # чтение данных о граничной мощности и необходимости уведомления
    # о ее превышении
    result = connect.exec("SELECT alarm_value, alarm_on
                           FROM meters
                           WHERE id = #{line_params.meter_id}")

    # если таких данных нет, то отключаем сигнализацию по граничной мощности
    if result.num_tuples = 0
      result = []
      result[0] = {'alarm_value' => 0, 'alarm_on' => 'f'}
    end

    connect.exec("INSERT INTO energies
                (meter_id, time, total, yesterday, today, period, power, factor, voltage, current,
                created_at, updated_at, alarm_value, alarm_on)
                VALUES
                (#{line_params.meter_id}, '#{line_params.time}', #{line_params.total},
                #{line_params.yesterday}, #{line_params.today}, #{line_params.period},
                #{line_params.power}, #{line_params.factor}, #{line_params.voltage},
                #{line_params.current}, '#{Time.now}', '#{Time.now}', 
                #{result[0]['alarm_value']}, #{result[0]['alarm_on'] == 't' ? 'true' : 'false'})")

    # отправка сообщения пользователю о превышении граничной мощности
    # if (result.first['alarm_on'] != 0) && (line_params.period > result.first['alarm_power'])
    #   sender_result = sender.send_message
    #   puts sender_result[:message].red
    # end
  end
end
