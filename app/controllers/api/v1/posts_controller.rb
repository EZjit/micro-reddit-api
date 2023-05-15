# frozen_string_literal: true

class Api::V1::PostsController < ApplicationController
  before_action :set_community
  before_action :ensure_authorship, only: %i[update delete]
  before_action :set_post, except: %i[create index]

  # GET /api/v1/communities/{community_name}/posts
  def index
    @pagy, @records = pagy(@community.posts)
    render json: @records, status: 200
  end

  # GET /api/v1/communities/{community_name}/posts/{post_id}
  def show
    render json: @post, status: 200
  end

  # POST /api/v1/communities/{community_name}/posts
  def create
    @post = Post.new(post_params)
    if @post.save
      render json: @post, status: 201
    else
      render json: { errors: @post.errors.full_messages }, status: 422
    end
  end

  # PUT /api/v1/communities/{community_name}/posts/{post_id}
  def update
    render json: { errors: @post.errors.full_messages }, status: 422 unless @post&.update(post_params)
    render json: @post
  end

  # DELETE /api/v1/communities/{community_name}/posts/{post_id}
  def destroy
    render json: { errors: @post.errors.full_messages }, status: 422 unless @post&.destroy
    render json: { notice: 'Post was successfully deleted' }
  end

  private

  def post_params
    params.permit(%i[title body parent])
  end

  def set_community
    @community = Community.find(param[:community_id])
  end

  def set_post
    @post = Post.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { errors: 'Post not found' }, status: 404
  end

  def ensure_authorship
    author?(set_post)
  end
end
