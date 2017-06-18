class LibroResource < JSONAPI::Resource

  model_name "Book"
  has_one :writer, class_name: 'Author', relation_name: :author, always_include_linkage_data: true, foreign_key: :author_id
  has_one :author, class_name: 'Writer', relation_name: :writer

end
