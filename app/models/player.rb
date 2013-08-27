class Player < ActiveRecord::Base
  include Tokenable
  include TimestampSuppress

  has_many :boards, dependent: :delete_all
  has_many :shoots, dependent: :delete_all
  has_many :games, through: :boards

  validates :name, presence: true
end
