class Api::V1::EventsController < ApplicationController
  include Pagination

  def index
    events = Event.published.order(created_at: :desc).page(params[:page] || 1).per(10).includes([:user])
    render json: events, meta: pagination(events), adapter: :json
  end

  def show
    event = Event.published.find(params[:id])
    render json: event
  end
end
