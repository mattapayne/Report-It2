module TaggedModel
  extend ActiveSupport::Concern
    
  def has_all_tags?(tags_to_include)
    tags_to_include.all? { |t| self.tags.include?(t) }
  end
end
