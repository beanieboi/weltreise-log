class Entry
  JSON.mapping(
    id: Int64,
    longitude: Float64,
    latitude: Float64,
    description: String,
    image_url: String,
    created_at: {type: Time, converter: Time::Format.new("%FT%X%:z")}
  )

  def initialize(@id : Int64, @latitude : Float64, @longitude : Float64,
                 @description : String, @image_url : String,
                 @created_at : Time)
  end

  def exists_in_database?
    POSTGRES.query("SELECT 1 AS one FROM entries WHERE entries.id = $1 LIMIT 1", id) do |rs|
      rs.each do
        return true if rs.read(Int32) == 1
      end
    end
  end

  def save!
    POSTGRES.exec(
      "INSERT INTO entries values ($1, $2, $3, $4, $5, $6)",
      id,
      longitude,
      latitude,
      description,
      image_url,
      created_at
    )
  end

  def self.all
    entries = [] of Entry

    POSTGRES.query("SELECT id, latitude, longitude, description, image_url, created_at FROM entries ORDER BY id DESC") do |rs|
      rs.each do
        id = rs.read(Int64)
        latitude = rs.read(Float64)
        longitude = rs.read(Float64)
        description = rs.read(String)
        image_url = rs.read(String)
        created_at = rs.read(Time)

        entries << self.new(
          id: id,
          longitude: longitude,
          latitude: latitude,
          description: description,
          image_url: image_url,
          created_at: created_at
        )
      end
    end

    entries
  end
end
