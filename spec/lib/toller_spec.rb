# frozen_string_literal: true

require "rails_helper"

RSpec.describe Toller do
  describe ".truthy" do
    it "returns true for truthy strings" do
      %w[1 t true y yes].each do |value|
        expect(described_class.truthy(value)).to be(true)
      end
    end

    it "returns false for other strings" do
      %w[0 no].each do |value|
        expect(described_class.truthy(value)).to be(false)
      end
    end
  end
end
