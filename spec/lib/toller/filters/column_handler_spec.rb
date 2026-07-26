# frozen_string_literal: true

require "rails_helper"

RSpec.describe Toller::Filters::ColumnHandler do
  subject(:handler) { described_class.new }

  let!(:foo_post) { Post.create(title: "Foo Post") }

  before { Post.create(title: "Bar Post") }

  describe "#call" do
    context "when :field is a real column" do
      it "filters the collection" do
        result = handler.call(Post.all, :string, "Foo Post", field: :title)

        expect(result.to_a).to eq([foo_post])
      end
    end

    context "when :field is not a real column" do
      before { allow(Rails.logger).to receive(:warn) }

      it "returns the collection unchanged" do
        collection = Post.all

        result = handler.call(collection, :string, "Foo Post", field: :nonexistent_column)

        expect(result).to eq(collection)
      end

      it "logs a warning naming the missing column" do
        handler.call(Post.all, :string, "Foo Post", field: :nonexistent_column)

        expect(Rails.logger).to have_received(:warn).with(/no column `nonexistent_column`/)
      end
    end
  end
end
