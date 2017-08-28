class AuthorResource < JSONAPI::Resource

  primary_key :id
  attributes :name, :address, :birth_name
  filters :name

  has_many :books, class_name: "Book", relation_name: :books, always_include_linkage_data: true

  def self.creatable_fields(context)
    super - [:address]
  end

  def self.updatable_fields(context)
    super - [:birth_name]
  end

end
