# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  context 'callbacks' do
    it { should use_before_action(:set_user) }
    it { should use_before_action(:authenticate_user) }
  end

  let!(:users) { create_list(:user, Pagy::DEFAULT[:items]) }
  let!(:user) { users.sample }

  describe 'POST #create' do
    let(:valid_attributes) { attributes_for(:user) }
    let(:invalid_attributes) { attributes_for(:user, email: nil) }

    context 'with valid attributes' do
      before { post :create, params: valid_attributes }

      it 'creates a new user' do
        expect(User.all.count).to be(Pagy::DEFAULT[:items] + 1)
      end

      it { should respond_with(:created) }
    end

    context 'with invalid attributes' do
      before { post :create, params: invalid_attributes }

      it 'does not create a new user' do
        expect(User.all.count).to be(Pagy::DEFAULT[:items])
      end

      it { should respond_with(:unprocessable_entity) }
    end
  end



  describe 'GET #index' do
    before do
      get_auth_token(user)
      get :index
    end
    it { should respond_with(:ok) }
    it 'should return all users' do
      expect(JSON.parse(response.body).size).to be Pagy::DEFAULT[:items]
    end
  end

  describe 'GET #show, {username}' do
    before { get_auth_token(user) }
    context 'user with #username exists' do
      before { get :show, params: { username: user.username } }
      it { should respond_with(:ok) }
      it 'should return a requested user' do
        expect(assigns(:user)).to eq(user)
      end
    end

  end
end
