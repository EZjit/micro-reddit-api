# frozen_string_literal: true

class Api::V1::CommentsController < ApplicationController
  before_action :set_post
  before_action :ensure_authorship, only: %i[update delete]
  before_action :set_comment, except: %i[create index]

  # GET /api/v1/communities/{community_name}/posts/{post_id}
  def index
    @pagy, @records = pagy(@post.comments)
    render json: @records, status: 200
  end

  # GET /api/v1/communities/{community_name}/posts/{post_id}/{comment_id}
  def show
    render json: @comment, status: 200
  end

  # POST /api/v1/communities/{community_name}/posts/{post_id}
  def create
    @comment = Comment.new(comment_params)
    if comment.save
      render json: @comment, status: 201
    else
      render json: { errors: @comment.errors.full_messages }, status: 422
    end
  end

  # PUT /api/v1/communities/{community_name}/posts/{post_id}/{comment_id}
  def update
    render json: { errors: @comment.errors.full_messages }, status: 422 unless @comment&.update(comment_params)
    render json: @comment
  end

  # DELETE /api/v1/communities/{community_name}/posts/{post_id}/{comment_id}
  def destroy
    render json: { errors: @comment.errors.full_messages }, status: 422 unless @comment&.destroy
    render json: { message: 'Comment was successfully deleted' }
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :parent)
  end

  def set_post
    @post = Post.find(params[:post_id]) or not_found('post')
  end

  def set_comment
    @comment = Comment.comment(params[:id]) or not_found('comment')
  end

  def ensure_authorship
    author?(set_comment)
  end
end
