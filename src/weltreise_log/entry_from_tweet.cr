class EntryFromTweet
  def from_tweets(tweets)
    entries = [] of Entry
    json = JSON.parse(tweets)

    json.as_a.each do |entry_json|
      entry = Entry.new(
        entry_json["id"].as_i64,
        parse_coordinates(entry_json["geo"]?)[0],
        parse_coordinates(entry_json["geo"]?)[1],
        entry_json["full_text"].as_s.gsub(/https:\/\/t\.co.\w{10}$/, ""),
        parse_image(entry_json["entities"]?),
        created_at: Time.parse(entry_json["created_at"].as_s, "%a %b %d %T %z %Y", Time::Location::UTC)
      )
      entries << entry
    end

    entries
  end

  private def parse_image(entities)
    if entities && entities["media"]?
      if entities["media"][0]["media_url_https"].as_s
        entities["media"][0]["media_url_https"].as_s
      else
        ""
      end
    else
      ""
    end
  end

  private def parse_coordinates(coords)
    if coords
      latitude = coords["coordinates"][0].as_f
      longitude = coords["coordinates"][1].as_f
      [latitude, longitude]
    else
      [0.0, 0.0]
    end
  end
end
