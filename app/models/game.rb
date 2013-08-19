class Game < ActiveRecord::Base
	has_many :shoots, dependent: :delete_all
	has_many :boards, dependent: :delete_all
	has_many :players, through: :boards
end
