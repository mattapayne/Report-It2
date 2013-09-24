class SnippetSerializer < ActiveModel::Serializer
  attributes :id, :name, :content
  
  def id
    object.id.to_s
  end
  
end
