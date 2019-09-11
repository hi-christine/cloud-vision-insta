require 'rmagick'
require 'json'

class RasterAnnotator
  attr_accessor :source_local_path, :destination_local_path

  def initialize(source_local_path, destination_local_path)
    @source_local_path = source_local_path
    @destination_local_path = destination_local_path

    @image_list = Magick::ImageList.new(source_local_path)
  end

  # Just provide an array of four points (something with attributes X and Y, or a hash with keys X and Y)
  def draw_rect(x_y_point_array)

    points = if x_y_point_array[0].class == Hash
      x_y_point_array.map { |p| Point.new(p["x"], p["y"]) }
             else
      x_y_point_array.map { |p| Point.new(p.x, p.y) }
             end

    left_top = points[0]
    right_bottom = points[0]
    points.shift

    points.each do |p|
      left_top = left_top.closest_to_origin(p)
      right_bottom = right_bottom.closest_to_extent(p)
    end

    gc = Magick::Draw.new

    gc.fill_opacity(0)
    gc.stroke('red')
    gc.stroke_width(3)

    gc.rectangle(left_top.x, left_top.y, right_bottom.x, right_bottom.y)
    gc.draw(@image_list)
  end

  #expects one instance from the json["responses"]["faceAnnotations"] array
  def point_face_landmarks(face_annotation)
    gc = Magick::Draw.new

    gc.fill_opacity(0)
    gc.stroke('green')
    gc.stroke_width(2)

    landmarks_array = face_annotation["landmarks"]
    landmarks_array.each do |landmark|
      position = landmark["position"]
      gc.circle(position["x"], position["y"], position["x"] + 2, position["y"])
    end

    gc.draw(@image_list)
  end

  def save_destination_file
    @image_list.write(@destination_local_path)
  end

end

class Point
  attr_accessor :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  #returns true if the candidate point is closer to the image origin (0,0) than this point
  def is_closer_to_origin(candidate)
    candidate.x <= @x && candidate.y <= @y
  end

  # returns true if the candidate point is closer to the bottom left corner of the image (xMax, yMax).
  # There's probably an exact term, but I don't know it, so I named it 'extent'
  def is_closer_to_extent(candidate)
    candidate.x >= @x && candidate.y >= @y
  end

  #returns the point closest to the origin.
  def closest_to_origin(candidate)
    return candidate if is_closer_to_origin(candidate)

    self
  end

  #returns the point closest to the extent.
  def closest_to_extent(candidate)
    return candidate if is_closer_to_extent(candidate)

    self
  end
end
