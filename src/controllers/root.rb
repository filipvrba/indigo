require_relative "../base/indigo"

module Controllers
  class Root < Indigo::Base
    get "/" do
      @title = "#{@db.root.parse(:app_name)} | Root"
      @meta[:og_site_name] = @title

      ren(:root) do
        erb @via.render "root/index"
      end
    end
  end
end
