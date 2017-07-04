require "./weltreise_log/*"
require "kemal"

get "/" do
  "Hello World!"
end

Kemal.run
