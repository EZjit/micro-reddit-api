# == Schema Information
#
# Table name: posts
#
#  id           :bigint           not null, primary key
#  title        :string
#  body         :string
#  user_id      :bigint           not null
#  community_id :bigint           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :body
  has_many :comments
end
