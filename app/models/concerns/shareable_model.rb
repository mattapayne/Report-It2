module ShareableModel
  extend ActiveSupport::Concern
  
  included do
    after_destroy :remove_shares
    after_create :add_to_creator
  end
  
  def self.included(klass)
    klass.extend(ClassMethods)
  end
  
  module ClassMethods
    
    attr_reader :shared_collection_name
    
    def user_shared_collection_name(name)
      @shared_collection_name = name.to_sym
    end
    
  end
  
  def share_with!(user)
    unless owns?(user) || shared?(user)
      ensure_associated!(user)
        shared_collection(user) << self.id
        user.save!
        Rails.logger.debug "Shared #{self} with #{user}."
    else
      raise "This #{model_name} cannot be shared with #{user.full_name}, because the user is the creator or already has the share."
    end
  end
  
  def unshare_with!(user)
    unless owns?(user)
      if shared?(user)
        shared_collection(user).delete(self.id)
        user.save!
        Rails.logger.debug "Stopped sharing #{self} with #{user}."
      end
    end
  end
  
  def owned_by_or_shared_with?(user)
    owns?(user) || shared?(user)
  end
  
  def shared?(user)
    shared_collection(user).include?(self.id)
  end
  
  def owns?(user)
    self.creator.id == user.id
  end
  
  protected
  
  def shared_collection_name
    self.class.shared_collection_name
  end
  
  def remove_shares
    User.any_in(self.shared_collection_name => self.id).pull(self.shared_collection_name => self.id)
    Rails.logger.debug "I was destroyed. Removing all references to myself from all user's #{self.shared_collection_name}."
  end
  
  def add_to_creator
    shared_collection(self.creator) << self.id
    self.creator.save!
    Rails.logger.debug "Added #{self} to creator."
  end
  
  def model_name
    return self.class.name.titleize.downcase
  end
  
  private
  
  #this accesses the collection that contains this ids of the shared items (reports or report templates currently)
  #if the collection is nil, we initialize it to an empty array
  def shared_collection(user)
    collection = user.send(self.shared_collection_name)
    if collection.nil?
      collection = []
      user.send("#{self.shared_collection_name}=".to_sym, collection)
    end
    collection
  end
  
  def ensure_associated!(user)
    unless self.creator.associated_with?(user)
      raise "The user: #{user.full_name} is not an associate of #{self.creator.full_name}"
    end
  end
end

