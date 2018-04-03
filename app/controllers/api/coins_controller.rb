class Api::CoinsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_coin, only: [:show, :update, :destroy]
  BASE_URL = 'https://api.coinmarketcap.com/v1/ticker/'

  def index
    coins = HTTParty.get(BASE_URL)
    user_coins = current_user.coins
    user_coins.each do |coin|
      res_coin = coins.find { |c| c['id'] == coin.cmc_id }
      coin.update(price: res_coin['price_usd']) if res_coin
    end

    render json: current_user.coins
  end

  def create
    cmc_id = params[:coin].downcase
    res = HTTParty.get("#{BASE_URL}#{cmc_id}")
    if coin = Coin.create_by_cmc_id(res)
      watched = WatchedCoin.find_or_create_by(
        coin_id: coin.id,
        user_id: current_user.id
      )
      watched.update(initial_price: coin.price) if watched.initial_price.nil?
      render json: coin
    else
      render json: { errors: 'Coin Not Found' }, status: 422
    end

    #find out if the coin exists on cmc
    #create a coin in our database (or find it)
    #create a watched_coin record
    #render back the coin
  end

  def show
    render json: @coin
  end

  # PUT /api/coins/:id
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