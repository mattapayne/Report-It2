module ShareableModel
  extend ActiveSupport::Concern

  def share_with!(user)
    unless self.creator.id == user.id
      check_association_between_users(user)
      unless currently_shared_between?(self.creator, user)
        #TODO - can a user that has the item shared to them also share it to someone else?
        self.shares.create!(shared_by: self.creator, shared_with: user)
      end
    else
      raise "This #{model_name} cannot be shared with #{user.full_name}, because the user is the creator."
    end
  end
  
  def unshare_with!(user)
    unless self.creator.id == user.id
      if currently_shared_between?(self.creator, user)
        share = self.shares.where(shared_by: self.creator, shared_with: user).first
        self.shares.delete(share)
        before_destroy_share(user, share)
        share.destroy
      end
    end
  end
  
  def currently_shared_between?(sharer, sharee)
    self.shares.where(shared_by: sharer, shared_with: sharee).exists?
  end
  
  def model_name
    return self.class.name.titleize.downcase
  end
  
  protected
  
  def before_destroy_share(user, share)
    #hook - do nothing here
  end
  
  private
  
  def check_association_between_users(user)
    unless self.creator.associated_with?(user)
      raise "The user: #{user.full_name} is not an associate of #{self.creator.full_name}"
    end
  end
end

