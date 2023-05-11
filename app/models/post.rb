# frozen_string_literal: true

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
class Post < ApplicationRecord
  belongs_to :user
  belongs_to :community
  has_many :comments, inverse_of: :post

  validates :title, presence: true, length: { within: 3..80 }
  validates :body, presence: true
end
