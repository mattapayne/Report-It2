class UserSetting
  include Mongoid::Document
  
  field :key
  field :value
  
  validates_presence_of :key
  validates_length_of :key, minimum: 3
  
  embedded_in :user
  
  def self.default_settings
    [new({key: 'image_height', value: 360 }), new({key: 'image_width', value: 400})]
  end
end
