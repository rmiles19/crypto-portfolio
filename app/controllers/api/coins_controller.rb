class Api::CoinsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_coin, only: [:show, :update, :destroy]
  BASE_URL = 'https://api.coinmarketcap.com/v1/ticker/'

  def index
    render json: current_user.coins 
  end

  def create
  end

  def show
    render json: @coin 
  end

  def update
  end

  def destroy
    @coin.destroy
  end
end
