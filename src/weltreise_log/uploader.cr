require "awscr-s3"

KEY    = ENV["AWS_ACCESS_KEY_ID"]
SECRET = ENV["AWS_SECRET_ACCESS_KEY"]

class Uploader
  def initialize
    @bucket = "weltreise-log"
    @region = "eu-central-1"
    @host = "#{@bucket}.s3.amazonaws.com"
  end

  def upload!(key, content : IO::Memory)
    resp = form(key).submit(content)

    if resp.status_code == 201
      puts "Upload was a success: #{resp.headers["Location"]}"
    else
      puts "Upload failed: #{resp.status_code}:\n\n#{resp.body}"
    end
  end

  private def form(key)
    Awscr::S3::Presigned::Form.build(@region, KEY, SECRET) do |form|
      form.expiration(Time.unix(Time.now.to_unix + 1000))
      form.condition("bucket", @bucket)
      form.condition("acl", "public-read")
      form.condition("key", key)
      form.condition("Content-Type", "application/json")
      form.condition("success_action_status", "201")
    end
  end
end
