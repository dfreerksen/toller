# frozen_string_literal: true

require "rails_helper"

RSpec.describe Toller::Filters::Mutators::Date do
  describe ".call" do
    context "when the value has no range syntax" do
      it "returns the value unchanged" do
        expect(described_class.call("2024-01-01")).to eq("2024-01-01")
      end
    end

    context "when the value has inclusive (`..`) range syntax" do
      it "returns an inclusive Range" do
        expect(described_class.call("2024-01-01..2024-12-31")).to eq("2024-01-01".."2024-12-31")
      end
    end

    context "when the value has exclusive (`...`) range syntax" do
      subject(:result) { described_class.call("2024-01-01...2024-12-31") }

      it "returns an exclusive Range" do
        expect(result).to eq("2024-01-01"..."2024-12-31")
      end

      it "excludes the end value" do
        expect(result.exclude_end?).to be(true)
      end
    end
  end
end
