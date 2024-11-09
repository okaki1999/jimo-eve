class Api::V1::Current::EventsController < Api::V1::BaseController
  before_action :authenticate_user!

  def avatar_url
    Rails.application.routes.url_helpers.rails_blob_url(avatar, only_path: false) if avatar.attached?
  end

  def index
    events = current_user.events.not_unsaved.order(created_at: :desc)
    render json: events
  end

  def show
    event = current_user.events.find_by(id: params[:id])
    if event
      avatar_url = event.avatar.attached? ? url_for(event.avatar) : nil
      render json: event.as_json.merge(avatar_url: avatar_url)
    else
      render json: { error: "Event not found" }, status: :not_found
    end
  end

  def create
    unsaved_event = current_user.events.unsaved.first || current_user.events.create!(status: :unsaved)
    render json: unsaved_event
  end

  def update
    event = current_user.events.find(params[:id])
    if params[:event][:avatar].present?
      event.avatar.purge_later if event.avatar.attached?
      event.avatar.attach(params[:event][:avatar])
    end
    if event.update
      render json: event
    else
      render json: { errors: event.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def event_params
    params.require(:event).permit(:title, :content, :status, :image, :avatar)
  end
end
