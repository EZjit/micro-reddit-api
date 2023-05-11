# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  name            :string
#  username        :string
#  email           :string
#  password_digest :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  is_admin        :boolean          default(FALSE)

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    describe 'username field' do
      it { should validate_presence_of(:username) }
      it { should validate_uniqueness_of(:username) }
      it { should validate_length_of(:username) }
    end

    describe 'email field' do
      it { should validate_presence_of(:email) }
      it { should validate_uniqueness_of(:email) }
      it { should allow_value('aaa@bbb.com').for(:email) } # valid password
      it { should_not allow_value('aaaaaa').for(:email) } # invalid password
    end

    describe 'password field' do
      it { should have_secure_password }
      it { should validate_presence_of(:password) }
      it { should validate_length_of(:password) }
      it { should validate_confirmation_of(:password) }
      it { should allow_value('0oK9Ij*uh').for(:password) } # valid password
      it { should_not allow_value('dasdD@as').for(:password) } # must contain a digit
      it { should_not allow_value('231ASDA$').for(:password) } # must contain a lowercase char
      it { should_not allow_value('314dasd$').for(:password) } # must contain a uppercase char
      it { should_not allow_value('313Dads').for(:password) } # must contain a symbol
    end
  end
end

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:posts) }
    it { should have_many(:comments) }
  end

  describe 'admin? method' do
    context 'admin user' do
      subject { build(:user, is_admin: true) }
      it 'should return true' do
        expect { subject.admin?.to be_truthy }
      end
    end
    context 'not-admin user' do
      subject { build(:user) }
      it 'should return false' do
        expect { subject.admin?.to be_falsey }
      end
    end
  end
end
