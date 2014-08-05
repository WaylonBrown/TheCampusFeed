require "spec_helper"

describe TagsController do
  describe "routing" do

    it "routes to #index" do
      get("/api/v1/tags").should route_to("tags#index", format: :json)
    end

    it "routes to #new" do
      get("/api/v1/tags/new").should route_to("tags#new", format: :json)
    end

    it "routes to #show" do
      get("/api/v1/tags/1").should route_to("tags#show", :id => "1", format: :json)
    end

    it "routes to #edit" do
      get("/api/v1/tags/1/edit").should route_to("tags#edit", :id => "1", format: :json)
    end

    it "routes to #create" do
      post("/api/v1/tags").should route_to("tags#create", format: :json)
    end

    it "routes to #update" do
      put("/api/v1/tags/1").should route_to("tags#update", :id => "1", format: :json)
    end

    it "routes to #destroy" do
      delete("/api/v1/tags/1").should route_to("tags#destroy", :id => "1", format: :json)
    end

  end
end
