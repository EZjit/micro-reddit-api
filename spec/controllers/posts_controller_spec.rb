# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::PostsController, type: :controller do
  context 'callbacks' do
    it { should use_before_action(:ensure_authorship) }
    it { should use_before_action(:set_community) }
    it { should use_before_action(:set_post) }
    it { should use_before_action(:authenticate_user) }
  end

  let!(:test_post) { create(:post) }
  let!(:community) { test_post.community }
  let!(:user) { test_post.user }
  let!(:posts) { create_list(:post, Pagy::DEFAULT[:items] - 1, community:, user:) }

  describe 'unauthenticated user does not have access to any action' do
    context '#index' do
      before { get :index, params: { community__name: community.name } }
      it { should respond_with(:unauthorized) }
    end
    context '#show' do
      before { get :show, params: { community__name: community.name, id: test_post.id } }
      it { should respond_with(:unauthorized) }
    end
    context '#create' do
      before do
        post :create, params: {
          community__name: community.name,
          post: {
            title: 'Title',
            body: 'Body'
          }
        }
      end
      it { should respond_with(:unauthorized) }
    end
    context '#update' do
      before do
        patch :update, params: {
          community__name: community.name, id: test_post.id,
          post: {
            title: 'updated title',
            body: 'updated body'
          }
        }
      end
      it { should respond_with(:unauthorized) }
    end
    context '#destroy' do
      before { delete :destroy, params: { community__name: community.name, id: test_post.id } }
      it { should respond_with(:unauthorized) }
    end
  end

  describe 'authenticated user' do
    before { get_auth_token(user) }
    describe 'GET #index' do
      before { get :index, params: { community__name: community.name } }
      it { should respond_with(:ok) }
      it 'should return all community posts' do
        expect(JSON.parse(response.body).size).to eq(community.posts.count)
      end
    end

    describe 'GET #show, {id}' do
      context 'post with #id exists' do
        before { get :show, params: { community__name: community.name, id: test_post.id } }
        it { should respond_with(:ok) }
        it 'should return a requested post' do
          expect(json_body['title']).to eq(test_post.title)
          expect(json_body['body']).to eq(test_post.body)
        end
      end

      context 'post with #id does not exist' do
        before { get :show, params: { community__name: community.name, id: 'some_id' } }
        it { should respond_with(:not_found) }
        it 'should return a JSON with an error' do
          expect(json_body['errors']).to eq('Post not found')
        end
      end
    end

    describe 'POST #create' do
      let(:valid_attributes) { { post: attributes_for(:post) } }
      let(:invalid_attributes) { { post: attributes_for(:post, title: nil) } }

      context 'with valid attributes' do
        before { post :create, params: { community__name: community.name }.merge(valid_attributes) }

        it 'creates a new post' do
          expect(community.posts.count).to be(Pagy::DEFAULT[:items] + 1)
        end

        it { should respond_with(:created) }
      end

      context 'with invalid attributes' do
        before { post :create, params: { community__name: community.name }.merge(invalid_attributes) }

        it 'does not create a new post' do
          expect(community.posts.count).to be(Pagy::DEFAULT[:items])
        end

        it { should respond_with(:unprocessable_entity) }
      end
    end

    describe 'PATCH #update{id}' do
      let(:valid_attributes) { { post: { title: 'updated title', body: 'updated body' } } }
      let(:invalid_attributes) { { post: { title: nil, body: 'updated body' } } }

      context 'post with #id exists' do
        before { patch :update, params: { community__name: community.name, id: test_post.id }.merge(valid_attributes) }
        it { should respond_with(:ok) }
        it 'should return updated post' do
          expect(json_body['title']).to eq(valid_attributes[:post][:title])
          expect(json_body['body']).to eq(valid_attributes[:post][:body])
        end
        it 'updates a post' do
          test_post.reload
          expect(test_post.title).to eq(valid_attributes[:post][:title])
          expect(test_post.body).to eq(valid_attributes[:post][:body])
        end
      end

      context 'post with #id does not exist' do
        before { patch :update, params: { community__name: community.name, id: 'some_id' } }
        it { should respond_with(:not_found) }
        it 'should return a JSON with an error' do
          expect(json_body['errors']).to eq('Post not found')
        end
      end

      context 'invalid attributes' do
        before { patch :update, params: { community__name: community.name, id: test_post.id }.merge(invalid_attributes) }
        it 'does not update a post attributes' do
          test_post.reload
          expect(test_post.title).not_to eq(invalid_attributes[:post][:title])
          expect(test_post.body).not_to eq(invalid_attributes[:post][:body])
        end

        it { should respond_with(:unprocessable_entity) }
      end

      context 'user trying to update post created by another user' do
        let(:another_user_post) { create(:post, community:) }

        before do
          patch :update, params: {
            community__name: community.name, id: another_user_post.id
          }.merge(valid_attributes)
        end
        it { should respond_with(:unauthorized) }
        it 'should return a JSON with an error' do
          expect(json_body['errors']).to eq('You are not allowed to do this')
        end
      end
    end

    describe 'DELETE #destroy{id}' do
      context 'post with #id exists' do
        before { delete :destroy, params: { community__name: community.name, id: test_post.id } }
        it { should respond_with(:no_content) }
        it 'should actually destroy a post' do
          get :show, params: { community__name: community.name, id: test_post.id }
          expect(response).to have_http_status(:not_found)
        end
      end

      context 'post with #id does not exist' do
        before { delete :destroy, params: { community__name: community.name, id: 'some_id' } }
        it { should respond_with(:not_found) }
        it 'should return a JSON with an error' do
          expect(json_body['errors']).to eq('Post not found')
        end
      end

      context 'user trying to delete post created by another user' do
        let(:another_user_post) { create(:post, community:) }

        before { delete :destroy, params: { community__name: community.name, id: another_user_post.id } }
        it { should respond_with(:unauthorized) }
        it 'should return a JSON with an error' do
          expect(json_body['errors']).to eq('You are not allowed to do this')
        end
      end
    end
  end
end
