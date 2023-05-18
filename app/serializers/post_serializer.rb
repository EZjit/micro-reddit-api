# == Schema Information
#
# Table name: posts
#
#  id           :bigint           not null, primary key
#  title        :string           not null
#  body         :string           not null
#  user_id      :bigint           not null
#  community_id :bigint           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :body
  belongs_to :user, serializer: UserSerializer
  belongs_to :community, serializer: CommunitySerializer
  has_many :comments
end
