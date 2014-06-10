require "spec_helper"

describe PartialsController do
  describe "routing" do

    it "routes to #index" do
      get("/partials").should route_to("partials#index")
    end

    it "routes to #new" do
      get("/partials/new").should route_to("partials#new")
    end

    it "routes to #show" do
      get("/partials/1").should route_to("partials#show", :id => "1")
    end

    it "routes to #edit" do
      get("/partials/1/edit").should route_to("partials#edit", :id => "1")
    end

    it "routes to #create" do
      post("/partials").should route_to("partials#create")
    end

    it "routes to #update" do
      put("/partials/1").should route_to("partials#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/partials/1").should route_to("partials#destroy", :id => "1")
    end

  end
end
