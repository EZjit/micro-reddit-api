# == Schema Information
#
# Table name: communities
#
#  id          :bigint           not null, primary key
#  name        :string           not null
#  description :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class CommunitySerializer < ActiveModel::Serializer
  attributes :id, :name, :description
  has_many :posts
end
