class MetersController < ApplicationController

  before_action :set_meter, only: [:destroy, :show]
  before_action :set_consumer, only: [:create, :destroy]

  def show
    @energies = @meter.energies.last(10)
    @chart_data = [{name: 'Power', data: {'10:00' => 100, '11:00' => 120, '12:00' => 140, '13:00' => 90, '14:00' => 110}}]
  end

  def create
    @meter = @consumer.meters.new(meter_params)
    if @meter.save
      redirect_to @consumer
    else
      render '/consumer/show'
    end
  end

  def destroy
    if @meter.destroy
      redirect_to @consumer
    else
      redirect_to :back
    end
  end

  private

  def set_meter
    @meter = Meter.find(params[:id])
  end

  def set_consumer
    @consumer = Consumer.find(params[:consumer_id])
  end

  def meter_params
    params.require(:meter).permit(:name, :k_trans, :alarm_value, :alarm_on)
  end
end
