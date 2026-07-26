# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Post sorting", type: :request do
  before do
    Post.create(title: "Foo Post", userID: 99)
    Post.create(title: "Bar Post", userID: 42)
  end

  describe "when sorting by `userID`, a genuinely mixed-case column, ascending (`?sort=userID`)" do
    before do
      get "/posts", params: { sort: "userID" },
                    headers: { accept: "application/json" }
    end

    it "returns the lowest userID first" do
      expect(json_response[0][:title]).to eq("Bar Post")
    end

    it "returns the highest userID last" do
      expect(json_response[-1][:title]).to eq("Foo Post")
    end
  end

  describe "when sorting by `userID` descending (`?sort=-userID`)" do
    before do
      get "/posts", params: { sort: "-userID" },
                    headers: { accept: "application/json" }
    end

    it "returns the highest userID first" do
      expect(json_response[0][:title]).to eq("Foo Post")
    end

    it "returns the lowest userID last" do
      expect(json_response[-1][:title]).to eq("Bar Post")
    end
  end

  describe "when the request casing differs from the declared parameter (`?sort=USERID`)" do
    before do
      get "/posts", params: { sort: "USERID" },
                    headers: { accept: "application/json" }
    end

    it "still matches and sorts the lowest userID first" do
      expect(json_response[0][:title]).to eq("Bar Post")
    end

    it "still matches and sorts the highest userID last" do
      expect(json_response[-1][:title]).to eq("Foo Post")
    end
  end
end
