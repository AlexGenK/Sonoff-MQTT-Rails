require 'json'

class ElectricalParams

	attr_reader :elmeter_id
	attr_reader :time
	attr_reader :total
	attr_reader :yesterday
	attr_reader :today
	attr_reader :period
	attr_reader :power
	attr_reader :factor
	attr_reader :voltage
	attr_reader :current
	

	def initialize(topic, message)
		parsed_message = JSON.parse(message)
		@elmeter_id = get_elmeter_id(topic)
		@time       = parsed_message['Time']
		@total     	= parsed_message['ENERGY']['Total']
		@yesterday 	= parsed_message['ENERGY']['Yesterday']
		@today     	= parsed_message['ENERGY']['Today']
		@period     = parsed_message['ENERGY']['Period']
		@power      = parsed_message['ENERGY']['Power']
		@factor     = parsed_message['ENERGY']['Factor']
		@voltage    = parsed_message['ENERGY']['Voltage']
		@current    = parsed_message['ENERGY']['Current']
	end

	private

	# получение номера счетчика из топика
	def get_elmeter_id(topic)
	  %r{/(.+)/}.match(topic)[1]
	end
end
