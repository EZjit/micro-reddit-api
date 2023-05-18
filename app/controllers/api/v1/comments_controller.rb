# frozen_string_literal: true

class Api::V1::CommentsController < ApplicationController
  before_action :set_post, only: %i[index create]
  before_action :set_comment, except: %i[create index]
  before_action :ensure_authorship, only: %i[update destroy]

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
    @comment.user = authenticate_user
    @comment.post = @post
    if @comment.save
      render json: @comment, status: 201, serializer: CommentSerializer
    else
      render json: { errors: @comment.errors.full_messages }, status: 422
    end
  end

  # PUT /api/v1/communities/{community_name}/posts/{post_id}/{comment_id}
  def update
    if @comment&.update(comment_params)
      render json: @comment, status: 200, serializer: CommentSerializer
    else
      render json: { errors: @comment.errors.full_messages }, status: 422
    end
  end

  # DELETE /api/v1/communities/{community_name}/posts/{post_id}/{comment_id}
  def destroy
    @comment&.destroy
    head :no_content
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :parent)
  end

  def set_post
    @post = Post.find_by(id: params[:post_id]) or not_found('post')
  end

  def set_comment
    @comment = Comment.find_by(id: params[:id]) or not_found('comment')
  end

  def ensure_authorship
    author?(set_comment)
  end
end
