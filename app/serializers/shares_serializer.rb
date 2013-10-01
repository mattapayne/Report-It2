class SharesSerializer < ActiveModel::Serializer
  has_many :users, each_serializer: ::ShareUserSerializer 
end
