require "spec_helper"

describe Api::V1::TagsController do
  describe "routing" do

    it "routes to #index" do
      get("/api/v1s").should route_to("api/v1s#index")
    end

    it "routes to #new" do
      get("/api/v1s/new").should route_to("api/v1s#new")
    end

    it "routes to #show" do
      get("/api/v1s/1").should route_to("api/v1s#show", :id => "1")
    end

    it "routes to #edit" do
      get("/api/v1s/1/edit").should route_to("api/v1s#edit", :id => "1")
    end

    it "routes to #create" do
      post("/api/v1s").should route_to("api/v1s#create")
    end

    it "routes to #update" do
      put("/api/v1s/1").should route_to("api/v1s#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/api/v1s/1").should route_to("api/v1s#destroy", :id => "1")
    end

  end
end
