# frozen_string_literal: true

class Api::V1::CommunitiesController < ApplicationController
  before_action :authorize_admin, only: %i[update destroy]
  before_action :set_community, except: %i[create index]

  # GET /api/v1/communities
  def index
    @pagy, @records = pagy(Community.all)
    render json: @records, status: 200
  end

  # GET /api/v1/communities/{community_name}
  def show
    render json: @community, status: 200
  end

  # POST /api/v1/communities
  def create
    @community = Community.new(community_params)
    if @community.save
      render json: @community, status: 201
    else
      render json: { errors: @community.errors.full_messages }, status: 422
    end
  end

  # PUT api/v1/communities/{community_name}
  def update
    render json: { errors: @community.errors.full_messages }, status: 422 unless @community&.update(community_params)
    render json: @community
  end

  # DELETE api/v1/communities/{community_name}
  def destroy
    render json: { errors: @community.errors.full_messages }, status: 422 unless @community&.destroy
    render json: { notice: 'Community was successfully deleted' }
  end

  private

  def community_params
    params.permit(%i[name description])
  end

  def set_community
    @community = Community.find(params[:name])
  rescue ActiveRecord::RecordNotFound
    render json: { errors: 'Community not found' }, status: 404
  end
end
