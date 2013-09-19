module ShipHelper
  include ShipModels

  def generate_ship_randomly(type, width, height)
    ship = Ship.new :t => type
    variants = ShipModels::SHIP_MODELS[type.to_sym]
    coordinates = variants.sample

    start_x = Random.new.rand(0..width  - (ship_model_width  coordinates))
    start_y = Random.new.rand(0..height - (ship_model_height coordinates))

    coordinates.each do |c|
      p = Position.new :x => c[:x] + start_x, :y => c[:y] + start_y
      ship.positions.push p
    end

    ship
  end

  def generate_ship(type, x, y, variant = 0)

    ship = Ship.new t: type.to_sym

    variants = ShipModels::SHIP_MODELS[type.to_sym]
    coordinates = variants[variant.to_i]

    coordinates.each do |c|
      p = Position.new x: (c[:x] + x.to_i), y: (c[:y] + y.to_i)
      ship.positions.push p
    end

    ship
  end
end