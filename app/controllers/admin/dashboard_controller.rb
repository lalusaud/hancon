module Admin
  class DashboardController < BaseController
    def show
      @news_posts = NewsPost.order(updated_at: :desc).limit(5)
      @events = Event.order(starts_at: :desc).limit(5)
      @galleries = Gallery.order(updated_at: :desc).limit(5)
    end
  end
end
