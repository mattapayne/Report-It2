class PagedNotificationsSerializer < ActiveModel::Serializer
  attributes :total_pages, :current_page, :has_next, :has_previous, :per_page
  has_many :items, key: :notifications, serializer: NotificationSerializer
  
  def has_next
    object.has_next?
  end
  
  def has_previous
    object.has_previous?
  end
end