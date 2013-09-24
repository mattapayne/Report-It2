class UserSetting
  include Mongoid::Document
  
  field :key
  field :value
  field :description
  field :validation_rule
  
  validates_presence_of :key
  validates_length_of :key, minimum: 3
  
  embedded_in :user
  
  def self.default_settings
    [
     new(
           {
             key: 'image_height',
             value: 360,
             description: 'Controls the resize height of uploaded images',
             validation_rule: 'MustBeInteger' }),
     new(
           {
             key: 'image_width',
             value: 400,
             description: 'Controls the resize width of uploaded images',
             validation_rule: 'MustBeInteger' 
             })
     ]
  end
end
