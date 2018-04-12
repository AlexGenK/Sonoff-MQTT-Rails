class ConsumersController < ApplicationController

  before_action :set_consumer, only: [:show, :edit, :update, :destroy]

  def index
    @consumers = Consumer.all.order(:name)
  end

  def new
    @consumer = Consumer.new
  end

  def create
    @consumer = Consumer.new(consumer_params)
    if @consumer.save
      redirect_to @consumer
    else
      render :new
    end
  end

  def show
    @meters = @consumer.meters.all.order(:name)
    @meter = @consumer.meters.new
  end

  def edit
  end

  def update
    if @consumer.update(consumer_params)
      redirect_to @consumer
    else
      render :edit
    end
  end

  def destroy
    if @consumer.destroy
      redirect_to consumers_path
    else
      redirect_to :back
    end
  end

  private

  def set_consumer
    @consumer = Consumer.find(params[:id])
  end

  def consumer_params
    params.require(:consumer).permit(:name, :phone)
  end
end
