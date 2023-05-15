# == Schema Information
#
# Table name: comments
#
#  id         :bigint           not null, primary key
#  body       :string           not null
#  post_id    :bigint           not null
#  user_id    :bigint           not null
#  parent_id  :bigint
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class CommentSerializer < ActiveModel::Serializer
  attributes :id, :body
  belongs_to :post
end
