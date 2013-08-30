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
      coordinates = get_random_unique_coordinates x_start, x_end, y_start, y_end, ship.positions
      p = Position.new :x => coordinates[:point_x], :y => coordinates[:point_y]
      x_start = coordinates[:point_x] - 1
      x_end = coordinates[:point_x] + 1
      y_start = coordinates[:point_y] - 1
      y_end = coordinates[:point_y] + 1

      ship.positions.push p
    end
    ship
  end

  def self.get_random_unique_coordinates(x_start, x_end, y_start, y_end, positions)
    point_x= rand(x_start..x_end)
    point_y = rand(y_start..y_end)
    positions.each do |p|
      if (p.x.equal? point_x) && (p.y.equal? point_y)
        x_start = point_x - 1
        x_end = point_x + 1
        y_start = point_y - 1
        y_end = point_y + 1
        return get_random_unique_coordinates x_start, x_end, y_start, y_end, positions
      end
    end
    coordinates = {:point_x => point_x, :point_y => point_y}
  end

  def print_ship(board_width=20, board_height=20)
    puts self.t
    board_height.times do |y|
      row=''
      board_width.times do |x|
        pixel = nil
        self.positions.each do |p|
          if (p.x.equal? x) && (p.y.equal? y)
            pixel = p
          end
        end
        row += pixel ? '[]' : '.^'
      end
      puts row
    end
  end

  def valid_points?
    #TODO: better validation
    @@SHIP_TYPES[self.t].eql? self.positions.size
  end

  def self.SHIP_TYPES
    @@SHIP_TYPES
  end

end
