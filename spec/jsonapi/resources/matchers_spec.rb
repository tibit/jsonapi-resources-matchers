require 'spec_helper'

describe JSONAPI::Resources::Matchers do

  it 'has a version number' do
    expect(JSONAPI::Resources::Matchers::VERSION).not_to be nil
  end

  describe "resource matchers", type: :resource do
    describe "attributes" do
      let(:author) { Author.new(name: "name", id: 1) }
      subject(:resource) { AuthorResource.new(author, {}) }
      context 'original without testing attribute value' do
        it { is_expected.to have_attribute(:name) }
        it { is_expected.to_not have_attribute(:created_at) }
      end
      context 'with attribute value tested' do
        it { is_expected.to have_attribute( :name, eq('name')) }
        it { is_expected.to_not have_attribute( :name, eq('fred')) }
        it { is_expected.to have_attribute( :name, start_with('na')) }
        it { is_expected.to_not have_attribute( :name, start_with('fr')) }
        it { is_expected.to have_attribute( :name, match(/a/))  }
        it { is_expected.to_not have_attribute( :name, match(/b/))  }
        it { is_expected.to have_attribute( :name, 'name')  }
        it { is_expected.to_not have_attribute( :name, 'fred')  }
      end
    end

    describe "sortable fields" do
      let(:author) { Author.new(name: "name") }
      subject(:resource) { AuthorResource.new(author, {}) }
      it { is_expected.to have_sortable_field(:name) }
      it { is_expected.to_not have_sortable_field(:created_at) }
    end

    describe "creatable fields" do
      let(:author) { Author.new(name: "name") }
      subject(:resource) { AuthorResource.new(author, {}) }
      it { is_expected.to have_creatable_fields(:name, :birth_name) }
      it { is_expected.to_not have_creatable_field(:created_at, :address) }
    end

    describe "updatable fields" do
      let(:author) { Author.new(name: "name") }
      subject(:resource) { AuthorResource.new(author, {}) }
      it { is_expected.to have_updatable_fields(:name, :address) }
      it { is_expected.to_not have_updatable_field(:created_at) }
    end

    describe "filters" do
      let(:author) { Author.new(name: "name") }
      subject(:resource) { AuthorResource.new(author, {}) }
      it { is_expected.to filter(:name) }
      it { is_expected.to_not filter(:created_at) }
    end

    describe "have many" do
      let!(:author) { Author.create(name: "name") }
      let!(:book) { Book.create(author: author) }
      subject(:resource) { AuthorResource.new(author, {}) }
      it { is_expected.to have_many(:books) }
      it { is_expected.to have_many(:books).with_class_name("Book") }
      it { is_expected.to have_many(:books).with_relation_name(:books).with_related_record(book) }
      it { is_expected.to_not have_many(:fans) }
    end

    describe "have one" do
      let(:book) { Book.new(id: 2) }
      subject(:resource) { BookResource.new(book, {}) }
      context 'original without testing related record' do
        it { is_expected.to have_one(:author) }
        it { is_expected.to have_one(:author).with_class_name("Author") }
        it { is_expected.to have_one(:author).with_relation_name(:author) }
      end
      context 'testing related record' do
        let(:author) { Author.create(name: "name") }
        let(:book) { Book.create(author: author) }
        it { is_expected.to have_one(:author).with_related_record( author) }
      end
    end


    describe "model name" do
      let(:book) { Book.new(id: 2) }
      subject(:resource) { BookResource.new(book, {}) }
      it { is_expected.to have_model_name("Book") }
      it { is_expected.to_not have_model_name("Libro") }
    end

    describe "primary key" do
      let(:author) { Author.new(name: "name") }
      subject(:resource) { AuthorResource.new(author, {}) }
      it { is_expected.to have_primary_key(:id) }
      it { is_expected.to_not have_primary_key(:name) }
    end
  end
end
