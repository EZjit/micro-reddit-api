# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::CommentsController, type: :controller do
  context 'callbacks' do
    it { should use_before_action(:ensure_authorship) }
    it { should use_before_action(:set_comment) }
    it { should use_before_action(:set_post) }
    it { should use_before_action(:authenticate_user) }
  end

  let!(:comment) { create(:comment) }
  let!(:nested_comment) { create(:comment, parent: comment, post: test_post) }
  let!(:test_post) { comment.post }
  let!(:community) { test_post.community }
  let!(:user) { comment.user }
  let!(:comments) { create_list(:comment, Pagy::DEFAULT[:items] - 2, post: test_post) }

  describe 'unauthenticated user does not have access to any action' do
    context '#index' do
      before { get :index, params: { community__name: community.name, post_id: test_post.id } }
      it { should respond_with(:unauthorized) }
    end
    context '#show' do
      before { get :show, params: { community__name: community.name, post_id: test_post.id, id: comment.id } }
      it { should respond_with(:unauthorized) }
    end
    context '#create' do
      before do
        post :create, params: {
          community__name: community.name,
          post_id: test_post.id,
          comment: { body: 'Body' }
        }
      end
      it { should respond_with(:unauthorized) }
    end
    context '#update' do
      before do
        patch :update, params: {
          community__name: community.name,
          post_id: test_post.id,
          id: comment.id,
          comment: { body: 'updated body' }
        }
      end
      it { should respond_with(:unauthorized) }
    end
    context '#destroy' do
      before { delete :destroy, params: { community__name: community.name, post_id: test_post.id, id: comment.id } }
      it { should respond_with(:unauthorized) }
    end
  end

  describe 'authenticated user' do
    before { get_auth_token(user) }
    describe 'GET #index' do
      before { get :index, params: { community__name: community.name, post_id: test_post.id } }
      it { should respond_with(:ok) }
      it 'should return all post comments' do
        expect(JSON.parse(response.body).size).to eq(test_post.comments.count)
      end
    end

    describe 'GET #show, {id}' do
      context 'comment with #id exists' do
        before { get :show, params: { community__name: community.name, post_id: test_post.id, id: comment.id } }
        it { should respond_with(:ok) }
        it 'should return a requested comment' do
          expect(json_body['body']).to eq(comment.body)
        end
      end

      context 'comment with #id does not exist' do
        before { get :show, params: { community__name: community.name, post_id: test_post.id, id: 'some_id' } }
        it { should respond_with(:not_found) }
        it 'should return a JSON with an error' do
          expect(json_body['errors']).to eq('Comment not found')
        end
      end
    end

    describe 'POST #create' do
      let(:valid_attributes) { { comment: { body: 'Comment body' } } }
      let(:invalid_attributes) { { comment: { body: nil } } }

      context 'with valid attributes' do
        before { post :create, params: { community__name: community.name, post_id: test_post.id }.merge(valid_attributes) }

        it 'creates a new comment' do
          expect(test_post.comments.count).to be(Pagy::DEFAULT[:items] + 1)
        end

        it { should respond_with(:created) }
      end

      context 'with invalid attributes' do
        before { post :create, params: { community__name: community.name, post_id: test_post.id }.merge(invalid_attributes) }

        it 'does not create a new comment' do
          expect(test_post.comments.count).to be(Pagy::DEFAULT[:items])
        end

        it { should respond_with(:unprocessable_entity) }
      end
    end

    describe 'PATCH #update{id}' do
      let(:valid_attributes) { { comment: { body: 'updated body' } } }
      let(:invalid_attributes) { { comment: { body: nil } } }

      context 'comment with #id exists' do
        before do
          patch :update, params: {
            community__name: community.name, post_id: test_post.id, id: comment.id
          }.merge(valid_attributes)
        end
        it { should respond_with(:ok) }
        it 'should return updated comment' do
          expect(json_body['body']).to eq(valid_attributes[:comment][:body])
        end
        it 'updates a comment' do
          comment.reload
          expect(comment.body).to eq(valid_attributes[:comment][:body])
        end
      end

      context 'comment with #id does not exist' do
        before { patch :update, params: { community__name: community.name, post_id: test_post.id, id: 'some_id' } }
        it { should respond_with(:not_found) }
        it 'should return a JSON with an error' do
          expect(json_body['errors']).to eq('Comment not found')
        end
      end

      context 'invalid attributes' do
        before do
          patch :update, params: {
            community__name: community.name, post_id: test_post.id, id: comment.id
          }.merge(invalid_attributes)
        end
        it 'does not update a comment attributes' do
          comment.reload
          expect(comment.body).not_to eq(invalid_attributes[:comment][:body])
        end

        it { should respond_with(:unprocessable_entity) }
      end

      context 'user trying to update comment created by another user' do
        let(:another_user_comment) { create(:comment, post: test_post) }

        before do
          patch :update, params: {
            community__name: community.name, post_id: test_post.id, id: another_user_comment.id
          }.merge(valid_attributes)
        end
        it { should respond_with(:unauthorized) }
        it 'should return a JSON with an error' do
          expect(json_body['errors']).to eq('You are not allowed to do this')
        end
      end
    end

    describe 'DELETE #destroy{id}' do
      context 'comment with #id exists' do
        before { delete :destroy, params: { community__name: community.name, post_id: test_post.id, id: comment.id } }
        it { should respond_with(:no_content) }
        it 'should actually destroy a comment' do
          get :show, params: { community__name: community.name, post_id: test_post.id, id: comment.id }
          expect(response).to have_http_status(:not_found)
        end
      end

      context 'comment with #id does not exist' do
        before { delete :destroy, params: { community__name: community.name, post_id: test_post.id, id: 'some_id' } }
        it { should respond_with(:not_found) }
        it 'should return a JSON with an error' do
          expect(json_body['errors']).to eq('Comment not found')
        end
      end

      context 'user trying to delete comment created by another user' do
        let(:another_user_comment) { create(:comment, post: test_post) }

        before do
          delete :destroy, params: {
            community__name: community.name, post_id: test_post.id, id: another_user_comment.id }
        end
        it { should respond_with(:unauthorized) }
        it 'should return a JSON with an error' do
          expect(json_body['errors']).to eq('You are not allowed to do this')
        end
      end
    end
  end
end
