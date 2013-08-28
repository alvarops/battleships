class Ship < ActiveRecord::Base
  has_many :positions, dependent: :delete_all

  belongs_to :board

  validates_inclusion_of :t, :in => [:carrier, :battleship, :submarine, :cruiser, :patrol]

  @@SHIP_TYPES = {:carrier => 5, :battleship => 4, :submarine => 3, :cruiser => 3, :patrol => 2}

  def t
    read_attribute(:t).to_sym
  end

  def t= (value)
    write_attribute(:t, value.to_s)
  end

  def self.generate(t, width, height)
    ship = Ship.new :t => t
    no_of_points = @@SHIP_TYPES[t.to_sym]
    x_start = 1
    x_end = width
    y_start = 1
    y_end = height

    no_of_points.to_i.times do
      first_point_x= rand(x_start..x_end)
      first_point_y = rand(y_start..y_end)
      p = Position.new :x => first_point_x, :y => first_point_y
      ship.positions.push p
    end
    ship
  end

  def valid_points?
    #TODO: better validation
    @@SHIP_TYPES[self.t].eql? self.positions.size
  end

  def self.SHIP_TYPES
    @@SHIP_TYPES
  end
end
