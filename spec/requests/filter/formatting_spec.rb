# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Post filtering", type: :request do
  before do
    Post.create(title: "Foo Post")
    Post.create(title: "Bar Post")
  end

  describe "when the filter key has mixed case (`?filters[TITLE]=Foo Post`)" do
    before do
      get "/posts", params: { filters: { TITLE: "Foo Post" } },
                    headers: { accept: "application/json" }
    end

    it "returns the matching item" do
      expect(json_response[0][:title]).to eq("Foo Post")
    end

    it "returns specific item count" do
      expect(json_response.size).to eq(1)
    end
  end

  describe "when the filter key has leading/trailing whitespace (`?filters[ title ]=Bar Post`)" do
    before do
      get "/posts", params: { filters: { " title " => "Bar Post" } },
                    headers: { accept: "application/json" }
    end

    it "returns the matching item" do
      expect(json_response[0][:title]).to eq("Bar Post")
    end

    it "returns specific item count" do
      expect(json_response.size).to eq(1)
    end
  end

  describe "when one filter key is malformed but another is well-formed" do
    before do
      get "/posts", params: { filters: { " Title " => "Bar Post", post_title: "Bar Post" } },
                    headers: { accept: "application/json" }
    end

    it "still applies the malformed key's filter rather than silently dropping it" do
      expect(json_response.size).to eq(1)
    end

    it "still applies the well-formed sibling filter" do
      expect(json_response[0][:title]).to eq("Bar Post")
    end
  end
end
