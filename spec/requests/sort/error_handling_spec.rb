# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Post sorting", type: :request do
  before do
    Post.create(title: "Foo Post")
    Post.create(title: "Bar Post")
  end

  describe "when sorting by a column that doesn't exist (`?sort=bogus_column`)" do
    before do
      allow(Rails.logger).to receive(:warn)

      get "/posts", params: { sort: "bogus_column" },
                    headers: { accept: "application/json" }
    end

    it "does not raise, leaving the collection's natural order" do
      expect(json_response[0][:title]).to eq("Foo Post")
    end

    it "logs a warning naming the missing column" do
      expect(Rails.logger).to have_received(:warn).with(/no column `nonexistent_column`/)
    end
  end

  describe "when sorting by a scope that doesn't exist (`?sort=bogus_scope`)" do
    before do
      allow(Rails.logger).to receive(:warn)

      get "/posts", params: { sort: "bogus_scope" },
                    headers: { accept: "application/json" }
    end

    it "does not raise, leaving the collection's natural order" do
      expect(json_response[0][:title]).to eq("Foo Post")
    end

    it "logs a warning naming the missing scope" do
      expect(Rails.logger).to have_received(:warn).with(/no scope `nonexistent_scope`/)
    end
  end
end
