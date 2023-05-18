# frozen_string_literal: true

class Api::V1::CommunitiesController < ApplicationController
  before_action :authorize_admin, only: %i[update destroy]
  before_action :set_community, except: %i[create index]

  # GET /api/v1/communities
  def index
    @pagy, @records = pagy(Community.all)
    render json: @records, status: 200, each_serializer: CommunitySerializer, include: ['posts']
  end

  # GET /api/v1/communities/{community_name}
  def show
    render json: @community, status: 200, serializer: CommunitySerializer, include: ['posts']
  end

  # POST /api/v1/communities
  def create
    @community = Community.new(community_params_for_create)
    if @community.save
      render json: @community, status: 201, serializer: CommunitySerializer
    else
      render json: { errors: @community.errors.full_messages }, status: 422
    end
  end

  # PUT api/v1/communities/{community_name}
  def update
    if @community&.update(community_params_for_update)
      render json: @community, status: 200, serializer: CommunitySerializer, include: ['posts']
    else
      render json: { errors: @community.errors.full_messages }, status: 422
    end
  end

  # DELETE api/v1/communities/{community_name}
  def destroy
    @community.destroy
    head :no_content
  end

  private

  def community_params_for_create
    params.require(:community).permit(%i[name description])
  end

  def community_params_for_update
    params.require(:community).permit(:description)
  end

  def set_community
    @community = Community.find_by_name(params[:_name]) or not_found('community')
  end
end
