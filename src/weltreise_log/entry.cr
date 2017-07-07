class Entry
  JSON.mapping(
    id: Int64,
    longitude: Float64,
    latitude: Float64,
    description: String,
    image_url: String,
    created_at: {type: Time, converter: Time::Format.new("%FT%X%:z")}
  )

  def initialize(@id : Int64, @longitude : Float64, @latitude : Float64,
                 @description : String, @image_url : String,
                 @created_at : Time)
  end

  def self.all
    entries = [] of Entry

    POSTGRES.query("SELECT id, longitude, latitude, description, image_url, created_at FROM entries") do |rs|
      rs.each do
        id = rs.read(Int64)
        longitude = rs.read(Float64)
        latitude = rs.read(Float64)
        description = rs.read(String)
        image_url = rs.read(String)
        created_at = rs.read(Time)

        entries << self.new(id, longitude, latitude, description, image_url, created_at)
      end
    end

    entries
  end
end
