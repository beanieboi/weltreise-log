class Client
  Host = "api.twitter.com"

  def initialize(consumer_key, consumer_secret, oauth_token, oauth_token_secret)
    consumer = OAuth::Consumer.new(Host, consumer_key, consumer_secret)
    token = OAuth::AccessToken.new(oauth_token, oauth_token_secret)

    @http_client = HTTP::Client.new(Host, tls: true, port: 443)

    consumer.authenticate(@http_client, token)
  end

  def tweets
    response = get("/1.1/statuses/user_timeline.json?screen_name=wiraufweltreise")
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
