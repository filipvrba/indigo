require_relative "application/indigo"

class App < Indigo::Application

  def initialize
    super

    @name_app = "Indigo"
  end

  get "/" do
    @message = @db.parse :message
    ren(:root)
  end
end
