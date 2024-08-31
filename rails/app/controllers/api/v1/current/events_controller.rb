class Api::V1::Current::EventsController < Api::V1::BaseController
  before_action :authenticate_user!

  def index
    events = current_user.events.not_unsaved.order(created_at: :desc)
    render json: events
  end

  def show
    event = current_user.events.find(params[:id])
    render json: event
  end

  def create
    unsaved_event = current_user.events.unsaved.first || current_user.events.create!(status: :unsaved)
    render json: unsaved_event
  end

  def update
    event = current_user.events.find(params[:id])
    event.update!(event_params)
    render json: event
  end

  private

    def event_params
      params.require(:event).permit(:title, :content, :status)
    end
  
end
