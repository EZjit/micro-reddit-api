# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::CommunitiesController, type: :controller do
  context 'callbacks' do
    it { should use_before_action(:authorize_admin) }
    it { should use_before_action(:set_community) }
    it { should use_before_action(:authenticate_user) }
  end

  let!(:communities) { create_list(:community, Pagy::DEFAULT[:items]) }
  let!(:community) { communities.sample }
  let!(:admin) { create(:user, is_admin: true) }
  let!(:user) { create(:user) }

  describe 'unauthenticated user does not have access to any action' do
    context '#index' do
      before { get :index }
      it { should respond_with(:unauthorized) }
    end
    context '#show' do
      before { get :show, params: { _name: community.name } }
      it { should respond_with(:unauthorized) }
    end
    context '#create' do
      before { post :create, params: { community: { name: 'name', description: 'description' } } }
      it { should respond_with(:unauthorized) }
    end
    context '#update' do
      before do
        patch :update, params: {
          _name: community.name, community: { name: 'name', description: 'description' }
        }
      end
      it { should respond_with(:unauthorized) }
    end
    context '#destroy' do
      before { delete :destroy, params: { _name: community.name } }
      it { should respond_with(:unauthorized) }
    end
  end

  describe 'authenticated user' do
    before { get_auth_token(user) }
    describe 'GET #index' do
      before { get :index }
      it { should respond_with(:ok) }
      it 'should return all communities' do
        expect(JSON.parse(response.body).size).to be Pagy::DEFAULT[:items]
      end
    end

    describe 'GET #show, {name}' do
      context 'community with #name exists' do
        before { get :show, params: { _name: community.name } }
        it { should respond_with(:ok) }
        it 'should return a requested community' do
          expect(json_body['name']).to eq(community.name)
          expect(json_body['description']).to eq(community.description)
        end
      end

      context 'community with #name does not exist' do
        before { get :show, params: { _name: 'invalid_name' } }
        it { should respond_with(:not_found) }
        it 'should return a JSON with an error' do
          expect(json_body['errors']).to eq('Community not found')
        end
      end
    end

    describe 'POST #create' do
      let(:valid_attributes) { attributes_for(:community) }
      let(:invalid_attributes) { attributes_for(:community, name: nil) }

      context 'with valid attributes' do
        before { post :create, params: { community: valid_attributes } }

        it 'creates a new community' do
          expect(Community.all.count).to be(Pagy::DEFAULT[:items] + 1)
        end

        it { should respond_with(:created) }
      end

      context 'with invalid attributes' do
        before { post :create, params: { community: invalid_attributes } }

        it 'does not create a new community' do
          expect(Community.all.count).to be(Pagy::DEFAULT[:items])
        end

        it { should respond_with(:unprocessable_entity) }
      end
    end

    describe 'PATCH #update{name}' do
      let(:valid_attributes) { { community: { description: 'Some other description' } } }
      let(:invalid_attributes) { { community: { description: nil } } }

      context 'not admin user trying to update community info' do
        before { patch :update, params: { _name: community.name }.merge(valid_attributes) }
        it { should respond_with(:unauthorized) }
        it 'should return a JSON with an error' do
          expect(json_body['errors']).to eq('Admin-only functionality')
        end
      end

      context 'admin user' do
        before { get_auth_token(admin) }
        context 'community with #name exists' do
          before { patch :update, params: { _name: community.name }.merge(valid_attributes) }
          it { should respond_with(:ok) }
          it 'should return updated community' do
            expect(json_body['description']).to eq(valid_attributes[:community][:description])
          end
          it 'updates a community' do
            community.reload
            expect(community.description).to eq(valid_attributes[:community][:description])
          end
        end

        context 'community with #name does not exist' do
          before { get :update, params: { _name: 'invalid_name' } }
          it { should respond_with(:not_found) }
          it 'should return a JSON with an error' do
            expect(json_body['errors']).to eq('Community not found')
          end
        end

        context 'invalid attributes' do
          before { patch :update, params: { _name: community.name }.merge(invalid_attributes) }
          it 'does not update a community attributes' do
            community.reload
            expect(community.description).not_to eq(invalid_attributes[:community][:description])
          end

          it { should respond_with(:unprocessable_entity) }
        end
      end
    end

    describe 'DELETE #destroy{name}' do
      context 'not admin user trying to delete community' do
        before { delete :destroy, params: { _name: community.name } }
        it { should respond_with(:unauthorized) }
        it 'should return a JSON with an error' do
          expect(json_body['errors']).to eq('Admin-only functionality')
        end
      end
      context 'admin user' do
        before { get_auth_token(admin) }
        context 'community with #name exists' do
          before { delete :destroy, params: { _name: community.name } }
          it { should respond_with(:no_content) }
          it 'should actually destroy a community' do
            get :show, params: { _name: community.name }
            expect(response).to have_http_status(:not_found)
          end
        end

        context 'community with #name does not exist' do
          before { delete :destroy, params: { _name: 'invalid_name' } }
          it { should respond_with(:not_found) }
          it 'should return a JSON with an error' do
            expect(json_body['errors']).to eq('Community not found')
          end
        end
      end
    end
  end
end
