# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Post sorting", type: :request do
  before do
    Post.create(title: "Foo Post")
    Post.create(title: "Bar Post")
  end

  describe "when the sort param has mixed case (`?sort=TITLE`)" do
    before do
      get "/posts", params: { sort: "TITLE" },
                    headers: { accept: "application/json" }
    end

    it "returns the first item first" do
      expect(json_response[0][:title]).to eq("Bar Post")
    end

    it "returns the last item last" do
      expect(json_response[-1][:title]).to eq("Foo Post")
    end
  end

  describe "when a descending sort param has mixed case (`?sort=-Title`)" do
    before do
      get "/posts", params: { sort: "-Title" },
                    headers: { accept: "application/json" }
    end

    it "returns the first item last" do
      expect(json_response[0][:title]).to eq("Foo Post")
    end

    it "returns the last item first" do
      expect(json_response[-1][:title]).to eq("Bar Post")
    end
  end

  describe "when the sort param has leading/trailing whitespace (`?sort= title `)" do
    before do
      get "/posts", params: { sort: " title " },
                    headers: { accept: "application/json" }
    end

    it "returns the first item first" do
      expect(json_response[0][:title]).to eq("Bar Post")
    end

    it "returns the last item last" do
      expect(json_response[-1][:title]).to eq("Foo Post")
    end
  end

  describe "when chained sort params have whitespace around the comma (`?sort= -title, id`)" do
    before do
      get "/posts", params: { sort: " -title, id" },
                    headers: { accept: "application/json" }
    end

    it "still applies the whitespace-padded `-title` descending" do
      expect(json_response[0][:title]).to eq("Foo Post")
    end

    it "still applies the whitespace-padded `id` ascending" do
      expect(json_response[-1][:title]).to eq("Bar Post")
    end
  end

  describe "when the sort is declared with a mixed-case parameter (`?sort=postTitle`)" do
    before do
      get "/posts", params: { sort: "postTitle" },
                    headers: { accept: "application/json" }
    end

    it "returns the first item first" do
      expect(json_response[0][:title]).to eq("Bar Post")
    end

    it "returns the last item last" do
      expect(json_response[-1][:title]).to eq("Foo Post")
    end
  end
end
