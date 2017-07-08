require "micrate"
require "pg"

Micrate::DB.connection_url = ENV["DATABASE_URL"]
Micrate::Cli.run
