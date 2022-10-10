require "./lib/via/lib/index"
require_relative "arguments"

cont_name = @options[:g_controller].downcase
files = {
  controller: "src/controllers/#{cont_name}.rb",
  config: "config.ru",
  db: "src/db.rb",
  json: "share/#{cont_name}.json",
  view: "views/#{cont_name}"
}

