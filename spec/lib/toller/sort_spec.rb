# frozen_string_literal: true

require "rails_helper"

RSpec.describe Toller::Sort do
  describe "#initialize" do
    it "accepts every type in Toller::VALID_TYPES" do
      Toller::VALID_TYPES.each do |type|
        expect { described_class.new(:title, type, {}) }.not_to raise_error
      end
    end

    it "raises ArgumentError for an unrecognized type" do
      expect { described_class.new(:title, :sting, {}) }
        .to raise_error(ArgumentError, /unknown type `:sting` for sort `title`/)
    end
  end
end
