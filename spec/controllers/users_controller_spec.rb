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
      before { get :show, params: { _username: user.username } }
      it { should respond_with(:ok) }
      it 'should return a requested user' do
        expect(json_body['username']).to eq(user.username)
        expect(json_body['email']).to eq(user.email)
      end
    end

    context 'user with #username does not exist' do
      before { get :show, params: { _username: 'invalid_username' } }
      it { should respond_with(:not_found) }
      it 'should return a JSON with an error' do
        expect(json_body['errors']).to eq('User not found')
      end
    end
  end

  describe 'PUT #update{username}' do
    before { get_auth_token(user) }
    let(:valid_attributes) { attributes_for(:user) }
    let(:invalid_attributes) { attributes_for(:user, email: nil) }
    context 'user with #username exists' do
      before { get :update, params: { _username: user.username }.merge(valid_attributes) }
      it { should respond_with(:ok) }
      it 'should return updated user' do
        expect(json_body['username']).to eq(valid_attributes[:username])
        expect(json_body['email']).to eq(valid_attributes[:email])
      end
      it 'updates a user' do
        user.reload
        expect(user.email).to eq(valid_attributes[:email])
      end
    end

    context 'user with #username does not exist' do
      before { get :update, params: { _username: 'invalid_username' } }
      it { should respond_with(:not_found) }
      it 'should return a JSON with an error' do
        expect(json_body['errors']).to eq('User not found')
      end
    end

    context 'invalid attributes' do
      before { get :update, params: { _username: user.username }.merge(invalid_attributes) }
      it 'does not update a user attributes' do
        user.reload
        expect(user.email).not_to eq(invalid_attributes[:email])
      end

      it { should respond_with(:unprocessable_entity) }
    end

    context 'user trying to update information of another user' do
      let(:another_user) { create(:user) }
      before { get :update, params: { _username: another_user.username }.merge(valid_attributes) }
      it { should respond_with(:unauthorized) }
      it 'should return a JSON with an error' do
        expect(json_body['errors']).to eq('You are not allowed to do this')
      end
    end
  end

  describe 'DELETE #destroy{username}' do
    before { get_auth_token(user) }
    context 'user with #username exists' do
      before { get :destroy, params: { _username: user.username }  }
      it { should respond_with(:no_content) }
    end

    context 'user with #username does not exist' do
      before { get :destroy, params: { _username: 'invalid_username' } }
      it { should respond_with(:not_found) }
      it 'should return a JSON with an error' do
        expect(json_body['errors']).to eq('User not found')
      end
    end

    context 'user trying to delete another user profile' do
      let(:another_user) { create(:user) }
      before { get :destroy, params: { _username: another_user.username } }
      it { should respond_with(:unauthorized) }
      it 'should return a JSON with an error' do
        expect(json_body['errors']).to eq('You are not allowed to do this')
      end
    end
  end
end
