class PagedAssociatesSerializer < ActiveModel::Serializer
  attributes :total_pages, :current_page, :has_next, :has_previous, :per_page
  has_many :items, key: :associates, serializer: SimpleUserSerializer
  
  def has_next
    object.has_next?
  end
  
  def has_previous
    object.has_previous?
  end
end