require 'spec_helper'

RSpec.describe JSONAPI::Resources::Matchers::HaveUpdatableField do

  describe "#description" do
    let(:matcher) { described_class.new(:friend_id, :name) }
    subject(:description) { matcher.description }
    it { is_expected.to eq "has updatable fields: friend_id, name"}
  end

  describe "#failure_message" do
    let(:author) { Author.new }
    let(:resource) { AuthorResource.new(author, {}) }
    let(:matcher) { described_class.new(:id, :name) }
    subject(:failure_message) { matcher.failure_message }

    before { matcher.resource = resource }

    it { is_expected.to eq "expected AuthorResource to have updatable fields: id"}
  end

  describe "#does_not_match?" do
    let(:author) { Author.new }
    let(:resource) { AuthorResource.new(author, {}) }

    before do
      matcher.does_not_match?(resource)
    end

    context "given fields that are updatable" do
      let(:matcher) { described_class.new(:name, :address) }
      it do
        expect(matcher.failure_message_when_negated).
          to eq "expected AuthorResource to not have updatable fields: name, address"
      end
    end

    context "given fields that are not updatable" do
      let(:matcher) { described_class.new(:id) }
      it "does not match" do
        expect(matcher.does_not_match?(resource)).to be true
      end
    end
  end

  describe "#matches?" do
    let(:author) { Author.new }
    let(:resource) { AuthorResource.new(author, {}) }

    context "given multiple symbols" do
      let(:matcher) { described_class.new(:name, :address) }

      it "is true" do
        expect(matcher.matches?(resource)).to be true
      end
    end

    context "given some are not updatable" do
      let(:matcher) { described_class.new(:name, :address, :birth_name) }

      it "is true" do
        expect(matcher.matches?(resource)).to be false
      end
    end

    context "given an array" do
      let(:matcher) { described_class.new(%i[name address]) }

      it "is true" do
        expect(matcher.matches?(resource)).to be true
      end
    end
  end

end
