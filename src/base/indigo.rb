require_relative "../application/via"
require_relative "../db"
require_relative "../constants"
require_relative "../helper"

require 'sinatra/base'
require "sinatra/reloader"
require "sinatra/cookies"

module Indigo
  class Base < Sinatra::Base
    attr_reader :via, :db

    configure :development do
      register Sinatra::Reloader
    end

    helpers Sinatra::Cookies

    def initialize
      super

      @via = Via::Application.new
      @db = Indigo::DB.instance

      @title = @db.root.parse(:app_name)
      @meta = {
        keywords: "cv životopis #{@db.root.parse(:author)} projekty projects",
        description: @db.root.parse(:description),
        author: @db.root.parse(:author),
        og_image: @db.root.parse(:og_image),
        og_image_alt: "#{@db.root.parse(:author)} author",
        og_site_name: @title,
        og_type: "object",
        og_title: @db.root.parse(:author),
        og_url: "",
        og_description: @db.root.parse(:description),
      }
    end

    def ren symbol, &callback
      @meta[:og_url] = request.url

      erb @via.render LAYOUT do
        erb @via.render symbol do
          callback.call
        end
      end
    end

    def autotarized symbol, &callback
      if cookies[:autotarized] == "true"
        callback.call
      else
        ren(:root) do
          erb @via.render "#{ symbol.to_s }/autotarized"
        end
      end
    end
  end
end
