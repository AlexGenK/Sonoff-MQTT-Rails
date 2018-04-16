class OpenController < ApplicationController
  before_action :set_meter, only: [:show]

  def show
    @energies = @meter.energies.last(10)
    @chart_data = Energy.select_data_for_chart("meter_id = #{@meter.id} AND time > '#{Time.now - (24 * 60 * 60)}'")
  end

  private

  def set_meter
    @meter = Meter.find_by(topic: params[:id])
  end
end
