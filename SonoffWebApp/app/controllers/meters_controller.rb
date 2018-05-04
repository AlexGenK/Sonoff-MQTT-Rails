class MetersController < ApplicationController

  before_action :set_meter, only: [:destroy, :show, :edit, :update]
  before_action :set_consumer, only: [:create, :destroy, :edit, :update]

  def show
    params[:period] ||= 'l24h'
    @energies = @meter.energies.last(10)
    if params[:period] == 'l24h'
      @chart_data = Energy.select_data_for_chart("meter_id = #{@meter.id} AND time > '#{Time.now - (24 * 60 * 60)}'")
    elsif params[:period] == 'given'
      @chart_data = Energy.select_data_for_chart("meter_id = #{@meter.id} AND time > '#{convert_time(params[:startTime])}'
                                                  AND time < '#{convert_time(params[:endTime])}'")
    end
    @chart_header = set_chart_header
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
  def set_chart_header
    params[:period] == 'l24h' ? 'in the last 24 hours' : "from #{params[:startTime]} to #{params[:endTime]}"
  end

  # парсинг текстового представления даты/времени и создание из него объекта DateTime
  def convert_time(time)
    Time.strptime(time, '%d.%m.%Y %H:%M')
  end

  def meter_params
    params.require(:meter).permit(:name, :k_trans, :alarm_value, :alarm_on)
  end
end
