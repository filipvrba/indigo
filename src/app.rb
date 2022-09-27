require_relative "application/indigo"

class App < Indigo::Application

  def initialize
    super

    @name_app = "Indigo"
    @message = @db.parse :message
  end

  get "/" do
    ren(:root)
  end
end
