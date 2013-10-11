class MyProfileImage
  include ActiveModel::Model
  extend CarrierWave::Mount
  mount_uploader :image, MyProfileUploader
  
  HEIGHT = 32
  WIDTH = 32
  
end