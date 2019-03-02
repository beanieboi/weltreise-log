class Polarsteps
  Host = "www.polarsteps.com"

  def initialize
    @http_client = HTTP::Client.new(Host, tls: true, port: 443)
  end

  def steps
    response = get("/api/trips/186610")

    steps = [] of Polarstep
    json = JSON.parse(response)

    json["all_steps"].as_a.each do |polarstep_json|
      polarstep = Polarstep.new(
        polarstep_json["location"]["lat"].as_f,
        polarstep_json["location"]["lon"].as_f
      )
      steps << polarstep
    end

    steps
  end

  private def get(path : String, params = {} of String => String)
    path += "?#{to_query_params(params)}" unless params.empty?

    response = @http_client.get(path)

    handle_response(response)
  end

  private def handle_response(response : HTTP::Client::Response)
    case response.status_code
    when 200..299
      response.body
    else
      raise "#{response.status_code} - #{response.body}"
    end
  end

  private def to_query_params(params : Hash(String, String))
    HTTP::Params.build do |form_builder|
      params.each do |key, value|
        form_builder.add(key, value)
      end
    end
  end
end
