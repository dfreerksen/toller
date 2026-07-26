# frozen_string_literal: true

require "rails_helper"

RSpec.describe Toller::Sorts::ColumnHandler do
  subject(:handler) { described_class.new }

  let!(:foo_post) { Post.create(title: "Foo Post") }
  let!(:bar_post) { Post.create(title: "Bar Post") }

  describe "#call" do
    context "when :field is a real column whose type matches the declared type" do
      it "orders the collection ascending" do
        result = handler.call(Post.all, :string, :asc, field: :title)

        expect(result.to_a).to eq([bar_post, foo_post])
      end

      it "orders the collection descending" do
        result = handler.call(Post.all, :string, :desc, field: :title)

        expect(result.to_a).to eq([foo_post, bar_post])
      end
    end

    context "when :field is not a real column" do
      before { allow(Rails.logger).to receive(:warn) }

      it "returns the collection unchanged" do
        collection = Post.all

        result = handler.call(collection, :string, :asc, field: :nonexistent_column)

        expect(result).to eq(collection)
      end

      it "logs a warning naming the missing column" do
        handler.call(Post.all, :string, :asc, field: :nonexistent_column)

        expect(Rails.logger).to have_received(:warn).with(/no column `nonexistent_column`/)
      end
    end

    context "when :field is a real column but the declared type doesn't match its actual type" do
      before { allow(Rails.logger).to receive(:warn) }

      it "returns the collection unchanged" do
        collection = Post.all

        result = handler.call(collection, :integer, :asc, field: :title)

        expect(result).to eq(collection)
      end

      it "logs a warning naming the type mismatch" do
        handler.call(Post.all, :integer, :asc, field: :title)

        expect(Rails.logger).to have_received(:warn).with(/is `string`, declared as `integer`/)
      end
    end
  end
end
