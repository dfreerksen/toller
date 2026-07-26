# frozen_string_literal: true

require "rails_helper"

RSpec.describe Toller::Sorts::ScopeHandler do
  subject(:handler) { described_class.new }

  let!(:foo_post) { Post.create(title: "Foo Post") }
  let!(:bar_post) { Post.create(title: "Bar Post") }

  describe "#call" do
    context "when :scope_name is a real scope" do
      it "orders the collection ascending" do
        result = handler.call(Post.all, :asc, scope_name: :the_title)

        expect(result.to_a).to eq([bar_post, foo_post])
      end

      it "orders the collection descending" do
        result = handler.call(Post.all, :desc, scope_name: :the_title)

        expect(result.to_a).to eq([foo_post, bar_post])
      end
    end

    context "when :scope_name is not a real scope" do
      before { allow(Rails.logger).to receive(:warn) }

      it "returns the collection unchanged" do
        collection = Post.all

        result = handler.call(collection, :asc, scope_name: :nonexistent_scope)

        expect(result).to eq(collection)
      end

      it "logs a warning naming the missing scope" do
        handler.call(Post.all, :asc, scope_name: :nonexistent_scope)

        expect(Rails.logger).to have_received(:warn).with(/no scope `nonexistent_scope`/)
      end
    end

    context "when :scope_name collides with a real ActiveRecord class method, not an own scope" do
      before { allow(Rails.logger).to receive(:warn) }

      it "does not invoke the inherited method" do
        handler.call(Post.all, :asc, scope_name: :delete_all)

        expect(Post.count).to eq(2)
      end

      it "logs a warning naming the unresolved scope rather than calling it" do
        handler.call(Post.all, :asc, scope_name: :delete_all)

        expect(Rails.logger).to have_received(:warn).with(/no scope `delete_all`/)
      end
    end
  end
end
