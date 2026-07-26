# frozen_string_literal: true

require "rails_helper"

RSpec.describe Toller::Filters::ScopeHandler do
  subject(:handler) { described_class.new }

  let!(:foo_post) { Post.create(title: "Foo Post", body: "has cats") }

  before { Post.create(title: "Bar Post", body: "has dogs") }

  describe "#call" do
    context "when :scope_name is a real scope" do
      it "scopes the collection" do
        result = handler.call(Post.all, "cats", scope_name: :filter_on_body_contains)

        expect(result.to_a).to eq([foo_post])
      end
    end

    context "when :scope_name is not a real scope" do
      before { allow(Rails.logger).to receive(:warn) }

      it "returns the collection unchanged" do
        collection = Post.all

        result = handler.call(collection, "cats", scope_name: :nonexistent_scope)

        expect(result).to eq(collection)
      end

      it "logs a warning naming the missing scope" do
        handler.call(Post.all, "cats", scope_name: :nonexistent_scope)

        expect(Rails.logger).to have_received(:warn).with(/no scope `nonexistent_scope`/)
      end
    end

    context "when :scope_name collides with a real ActiveRecord class method, not an own scope" do
      before { allow(Rails.logger).to receive(:warn) }

      it "does not invoke the inherited method" do
        handler.call(Post.all, "x", scope_name: :delete_all)

        expect(Post.count).to eq(2)
      end

      it "logs a warning naming the unresolved scope rather than calling it" do
        handler.call(Post.all, "x", scope_name: :delete_all)

        expect(Rails.logger).to have_received(:warn).with(/no scope `delete_all`/)
      end
    end
  end
end
