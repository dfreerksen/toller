# frozen_string_literal: true

require "rails_helper"

RSpec.describe Toller::Filters::Mutators::Boolean do
  describe ".call" do
    it "returns true for truthy strings regardless of case" do
      %w[1 t T true True TRUE y Y yes Yes YES].each do |value|
        expect(described_class.call(value)).to be(true)
      end
    end

    it "returns false for other strings" do
      %w[0 f false n no].each do |value|
        expect(described_class.call(value)).to be(false)
      end
    end
  end
end
