class Api::CoinsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_coin, only: [:show, :update, :destroy]
  BASE_URL = 'https://api.coinmarketcap.com/v1/ticker/'

  def index
    render json: current_user.coins 
  end

  def create
    cmc_id = params[:coin].downcase
    res = HTTPARTY.get('#{BASE_URL}#{cmc_id}')
    if coin = Coin.create_by_cmc_id(res)
      watched = WatchedCoin.find_or_create_by(
        coin_id: coin.id,
        user_id: current_user.id
      )
      watched.update(initial_price: coin.price) if watched.initial_price.nil?
    else
      render json: { errors: 'Coin Not Found' } , status: 422
  end

  def show
    render json: @coin 
  end

  # PUT /api/coins/:id --- DOES NOT UPDATE. instead of creating a whole new controller I will use this unused one.
  def update
    current_user
      .watched_coins
      .find_by(coin_id: @coin.id)
      .destroy 
  end

  def destroy
    @coin.destroy
  end
end
