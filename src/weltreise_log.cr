require "oauth"
require "http/client"
require "uri"
require "./weltreise_log/*"

# POSTGRES = DB.open(ENV["DATABASE_URL"])
# at_exit { POSTGRES.close }

client = Client.new(
  ENV["TWITTER_CONSUMER_KEY"],
  ENV["TWITTER_CONSUMER_SECRET"],
  ENV["TWITTER_ACCESS_TOKEN"],
  ENV["TWITTER_ACCESS_TOKEN_SECRET"]
)

puts client.tweets
