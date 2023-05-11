# == Schema Information
#
# Table name: communities
#
#  id          :bigint           not null, primary key
#  name        :string
#  description :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class CommunitySerializer < ActiveModel::Serializer
  attributes :id, :name, :description
  has_many :posts
end
