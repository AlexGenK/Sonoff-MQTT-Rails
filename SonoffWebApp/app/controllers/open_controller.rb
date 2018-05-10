class OpenController < ApplicationController
  before_action :set_meter, only: [:show]

  def show
    params[:period] ||= 'l24h'
    if params[:period] == 'l24h'
      @chart_data = Energy.select_data_for_chart("meter_id = #{@meter.id} AND time > '#{Time.now - (24 * 60 * 60)}'")
      @start_time = true
      @end_time = true
    elsif params[:period] == 'given'
      @start_time = MetersController.convert_time(params[:startTime])
      @end_time = MetersController.convert_time(params[:endTime])
      if @start_time && @end_time
        @chart_data = Energy.select_data_for_chart("meter_id = #{@meter.id} AND time > '#{@start_time}' AND time < '#{@end_time}'")
      else
        render :show
      end
    end
    @chart_header = MetersController.set_chart_header(params)
  end

  private

  def set_meter
    @meter = Meter.find_by(topic: params[:id])
  end

end
