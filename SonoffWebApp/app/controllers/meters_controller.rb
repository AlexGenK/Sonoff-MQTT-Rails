class MetersController < ApplicationController

  before_action :set_meter, only: [:destroy, :show, :edit, :update]
  before_action :set_consumer, only: [:create, :destroy, :edit, :update]

  def show
    @energies = @meter.energies.last(10)
    @chart_data = Energy.select_data_for_chart("meter_id = #{@meter.id} AND time > '#{Time.now - (24 * 60 * 60)}'")
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

  def meter_params
    params.require(:meter).permit(:name, :k_trans, :alarm_value, :alarm_on)
  end
end
