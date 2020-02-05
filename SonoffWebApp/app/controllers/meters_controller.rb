class MetersController < ApplicationController

  before_action :set_meter, only: [:destroy, :show, :edit, :update]
  before_action :set_consumer, only: [:create, :destroy, :edit, :update]

  def show
    params[:period] ||= 'l24h'
    params[:by_hour] ||= '0'
    if params[:period] == 'l24h'
      @chart_data = Energy.select_data_for_chart("meter_id = #{@meter.id} AND time > '#{Time.now - (24 * 60 * 60)}'", params[:by_hour]=='1')
      @start_time = true
      @end_time = true
    elsif params[:period] == 'given'
      @start_time = MetersController.convert_time(params[:startTime])
      @end_time = MetersController.convert_time(params[:endTime])
      if @start_time && @end_time
        @chart_data = Energy.select_data_for_chart("meter_id = #{@meter.id} AND time > '#{@start_time}' AND time < '#{@end_time}'", params[:by_hour]=='1')
      else
        render :show
      end
    end
    @chart_header = MetersController.set_chart_header(params)
  end

  def create
    @meter = @consumer.meters.new(meter_params)
    if @meter.save
      redirect_to @consumer
    else
      @meters = @consumer.meters.all.order(:name)
      render '/consumers/show'
    end
  end

  def destroy
    if @meter.destroy
      redirect_to @consumer
    else
      redirect_to :back
    end
  end

  def edit
  end

  def update
    if @meter.update(meter_params)
      redirect_to @consumer
    else
      render :edit
    end
  end

  private

  def set_meter
    @meter = Meter.find(params[:id])
  end

  def set_consumer
    @consumer = Consumer.find(params[:consumer_id])
  end

  # установка заголовка таблицы
  def self.set_chart_header(prm)
    variable_part = prm[:period] == 'l24h' ? I18n.t('pow_chart.last24') : I18n.t('pow_chart.period', start_time: prm[:startTime], end_time: prm[:endTime])
    I18n.t('pow_chart.header', period: variable_part)
  end

  # парсинг текстового представления даты/времени и создание из него объекта DateTime
  def self.convert_time(time)
    begin
      Time.strptime(time, '%d.%m.%Y %H:%M')
    rescue ArgumentError
      false
    end
  end

  def meter_params
    params.require(:meter).permit(:name, :k_trans, :alarm_value, :alarm_on, :by_hour)
  end
end
