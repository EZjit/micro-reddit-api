# frozen_string_literal: true

class Api::V1::PostsController < ApplicationController
  before_action :set_community, only: %i[index create]
  before_action :set_post, except: %i[create index]
  before_action :ensure_authorship, only: %i[update destroy]

  # GET /api/v1/communities/{community_name}/posts
  def index
    @pagy, @records = pagy(@community.posts)
    render json: @records, status: 200, each_serializer: PostSerializer, include: ['comments']
  end

  # GET /api/v1/communities/{community_name}/posts/{post_id}
  def show
    render json: @post, status: 200, serializer: PostSerializer, include: ['comments']
  end

  # POST /api/v1/communities/{community_name}/posts
  def create
    @post = Post.new(post_params)
    @post.community = @community
    @post.user = authenticate_user
    if @post.save
      render json: @post, status: 201, serializer: PostSerializer
    else
      render json: { errors: @post.errors.full_messages }, status: 422
    end
  end

  # PUT /api/v1/communities/{community_name}/posts/{post_id}
  def update
    if @post&.update(post_params)
      render json: @post, status: 200, serializer: PostSerializer, include: ['comments']
    else
      render json: { errors: @post.errors.full_messages }, status: 422
    end
  end

  # DELETE /api/v1/communities/{community_name}/posts/{post_id}
  def destroy
    @post&.destroy
    head :no_content
  end

  private

  def post_params
    params.require(:post).permit(%i[title body])
  end

  def ensure_authorship
    author?(set_post)
  end

  def set_community
    @community = Community.find_by_name(params[:community__name]) or not_found('community')
  end

  def set_post
    @post = Post.find_by(id: params[:id]) or not_found('post')
  end
end
