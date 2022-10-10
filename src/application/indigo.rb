module Indigo
  class Application < Sinatra::Application
    def initialize
      super

      @via = Via::Application.new
      @db = Indigo::DB.instance

      @title = "#{@db.root.parse(:app_name)} | Error"
      @meta = {
        keywords: "cv error",
        description: "Tuhle stránku zde nenalezneš.",
        author: @db.root.parse(:author),
        og_image: @db.root.parse(:og_image),
        og_image_alt: "#{@db.root.parse(:author)} author",
        og_site_name: @title,
        og_type: "object",
        og_title: "404",
        og_url: "",
        og_description: "Tuhle stránku zde nenalezneš.",
      }
    end

    configure do
      set :root, File.absolute_path("#{ROOT_PATH_CNF}", __FILE__)
    end

    not_found do
      ren(:root) do
        erb @via.render "not_found"
      end
    end

    def ren symbol, &callback
      @meta[:og_url] = request.url

      erb @via.render LAYOUT do
        erb @via.render symbol do
          callback.call
        end
      end
    end
  end
end