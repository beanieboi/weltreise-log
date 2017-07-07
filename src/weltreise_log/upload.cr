require "secure_random"
require "tempfile"
require "awscr-signer"

KEY    = ENV["AWS_KEY"]
SECRET = ENV["AWS_SECRET"]

class Upload
  def initialize(@file : File)
    @bucket = "weltreise-log"
    @region = "eu-central-1"
    @host = "#{@bucket}.s3.amazonaws.com"
  end

  def upload!
    resp = form.submit(@file)

    if resp.status_code == 201
      puts "Upload was a success: #{resp.headers["Location"]}"
    else
      puts "Upload failed: #{resp.status_code}:\n\n#{resp.body}"
    end
  end

  private def credentials
    Awscr::Signer::Credentials.new(KEY, SECRET)
  end

  private def form
    Awscr::Signer::Presigned::Form.build(@region, credentials) do |form|
      form.expiration(Time.epoch(Time.now.epoch + 1000))
      form.condition("bucket", @bucket)
      form.condition("acl", "public-read")
      form.condition("key", "/images/#{@file.path}")
      form.condition("Content-Type", "image/png")
      form.condition("success_action_status", "201")
    end
  end
end
