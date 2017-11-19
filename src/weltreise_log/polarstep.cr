class Polarstep
  JSON.mapping(
    lat: Float64,
    lon: Float64
  )

  def initialize(@lat : Float64, @lon : Float64)
  end
end
