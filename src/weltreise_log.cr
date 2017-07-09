require "oauth"
require "http/client"
require "uri"
require "json"
require "db"
require "pg"
require "./weltreise_log/*"

POSTGRES = DB.open(ENV["DATABASE_URL"])
at_exit { POSTGRES.close }

client = Client.new(
  ENV["TWITTER_CONSUMER_KEY"],
  ENV["TWITTER_CONSUMER_SECRET"],
  ENV["TWITTER_ACCESS_TOKEN"],
  ENV["TWITTER_ACCESS_TOKEN_SECRET"]
)

converter = EntryFromTweet.new
uploader = Uploader.new

tweets = client.tweets
entries = converter.from_tweets(tweets)

entries.each do |entry|
  if entry.exists_in_database?
    p "Skipped #{entry.id}"
  else
    entry.save!
    p "Saved #{entry.id}"
  end
end

uploader.upload!("weltreise-log.json", IO::Memory.new(Entry.all.to_json))
