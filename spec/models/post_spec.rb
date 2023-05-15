# frozen_string_literal: true

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

require 'rails_helper'

RSpec.describe Post, type: :model do
  context 'validations' do
    it { should validate_presence_of(:body) }
    it { should validate_presence_of(:title) }
    it { should validate_length_of(:title) }
  end

  context 'associations' do
    it { should have_many(:comments).inverse_of(:post) }
    it { should have_many(:comments).dependent(:destroy) }
    it { should belong_to(:user) }
    it { should belong_to(:community) }
  end
end
