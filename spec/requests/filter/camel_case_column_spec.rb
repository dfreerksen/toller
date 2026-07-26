# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Post filtering", type: :request do
  before do
    Post.create(title: "Foo Post", userID: 42)
    Post.create(title: "Bar Post", userID: 99)
  end

  describe "when filtering by `userID`, a genuinely mixed-case column (`?filters[userID]=42`)" do
    before do
      get "/posts", params: { filters: { userID: "42" } },
                    headers: { accept: "application/json" }
    end

    it "returns the matching item" do
      expect(json_response[0][:title]).to eq("Foo Post")
    end

    it "returns specific item count" do
      expect(json_response.size).to eq(1)
    end
  end

  describe "when the request casing differs from the declared parameter (`?filters[USERID]=99`)" do
    before do
      get "/posts", params: { filters: { USERID: "99" } },
                    headers: { accept: "application/json" }
    end

    it "still matches, since request keys are compared case-insensitively" do
      expect(json_response[0][:title]).to eq("Bar Post")
    end

    it "returns specific item count" do
      expect(json_response.size).to eq(1)
    end
  end
end
