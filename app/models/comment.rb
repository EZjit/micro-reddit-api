# == Schema Information
#
# Table name: comments
#
#  id         :bigint           not null, primary key
#  body       :string
#  post_id    :bigint           not null
#  user_id    :bigint           not null
#  parent_id  :bigint
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Comment < ApplicationRecord
  belongs_to :post, inverse_of: :comments
  belongs_to :user
  belongs_to :parent, optional: true, class_name: 'Comment', inverse_of: :comments

  has_many :comments, foreign_key: :parent_id, dependent: :destroy, inverse_of: :parent

  validates :body, presence: true, length: { maximum: 200 }
end
