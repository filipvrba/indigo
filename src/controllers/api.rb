require_relative "../base/indigo"

module Controllers
  class Api < Indigo::Base
    before do
      content_type "application/json"
    end

    get "/api/root" do
      JSON.pretty_generate(@db.root.db)
    end
  end
end
