class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :watched_coins, dependent: :destroy
  has_many :coins, through: :watched_coins

  include DeviseTokenAuth::Concerns::User
end
