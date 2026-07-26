# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Post filtering", type: :request do
  before do
    Post.create(title: "Foo Post")
    Post.create(title: "Bar Post")
  end

  describe "when filtering by a column that doesn't exist (`?filter[bogus_column]=x`)" do
    before do
      allow(Rails.logger).to receive(:warn)

      get "/posts", params: { filters: { bogus_column: "x" } },
                    headers: { accept: "application/json" }
    end

    it "does not raise, leaving the collection unfiltered" do
      expect(json_response.count).to eq(2)
    end

    it "logs a warning naming the missing column" do
      expect(Rails.logger).to have_received(:warn).with(/no column `nonexistent_column`/)
    end
  end

  describe "when filtering by a scope that doesn't exist (`?filter[bogus_scope]=x`)" do
    before do
      allow(Rails.logger).to receive(:warn)

      get "/posts", params: { filters: { bogus_scope: "x" } },
                    headers: { accept: "application/json" }
    end

    it "does not raise, leaving the collection unfiltered" do
      expect(json_response.count).to eq(2)
    end

    it "logs a warning naming the missing scope" do
      expect(Rails.logger).to have_received(:warn).with(/no scope `nonexistent_scope`/)
    end
  end
end
