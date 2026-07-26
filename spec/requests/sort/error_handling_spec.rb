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

  describe "when a `scope_name` collides with a real ActiveRecord class method " \
           "(`?sort=dangerous_scope_collision`, `scope_name: :delete_all`)" do
    before do
      allow(Rails.logger).to receive(:warn)

      get "/posts", params: { sort: "dangerous_scope_collision" },
                    headers: { accept: "application/json" }
    end

    it "does not invoke the inherited `delete_all` method, leaving records intact" do
      expect(Post.count).to eq(2)
    end

    it "logs a warning naming the unresolved scope rather than calling it" do
      expect(Rails.logger).to have_received(:warn).with(/no scope `delete_all`/)
    end
  end

  describe "when a sort's declared type doesn't match its column's actual type " \
           "(`?sort=mismatched_type`, `type: :integer, field: :title`)" do
    before do
      allow(Rails.logger).to receive(:warn)

      get "/posts", params: { sort: "mismatched_type" },
                    headers: { accept: "application/json" }
    end

    it "does not raise, leaving the collection's natural order" do
      expect(json_response[0][:title]).to eq("Foo Post")
    end

    it "logs a warning naming the type mismatch" do
      expect(Rails.logger).to have_received(:warn).with(/is `string`, declared as `integer`/)
    end
  end
end
