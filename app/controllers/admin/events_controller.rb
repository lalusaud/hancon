module Admin
  class EventsController < BaseController
    before_action :set_event, only: %i[edit update destroy]

    def index
      @events = Event.order(starts_at: :desc)
    end

    def new
      @event = Event.new
    end

    def create
      @event = Event.new(event_params)
      if @event.save
        redirect_to admin_events_path, notice: "Event saved."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @event.update(event_params)
        redirect_to admin_events_path, notice: "Event saved."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @event.destroy
      redirect_to admin_events_path, notice: "Event deleted."
    end

    private

    def set_event
      @event = Event.find(params[:id])
    end

    def event_params
      params.require(:event).permit(:title, :description, :starts_at, :ends_at, :location, :published)
    end
  end
end
