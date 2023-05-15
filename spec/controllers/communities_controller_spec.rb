# frozen_string_literal: true

require 'rails_helper'
# require 'jwt'

RSpec.describe Api::V1::CommunitiesController, type: :controller do
  context 'callbacks' do
    it { should use_before_action(:authorize_admin) }
    it { should use_before_action(:set_community) }
    it { should use_before_action(:authenticate_user) }
  end

  let!(:users) { create_list(:user, 5) }

  describe 'GET #index' do
    let(:user) { users.sample }
    before do
      get_auth_token(user)
      get :index
    end

    it { should respond_with(:ok) }

    it 'should return all users' do
      expect(User.all).to match_array(users)
    end
  end
end
