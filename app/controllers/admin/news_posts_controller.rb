module Admin
  class NewsPostsController < BaseController
    before_action :set_news_post, only: %i[edit update destroy]

    def index
      @news_posts = NewsPost.order(updated_at: :desc)
    end

    def new
      @news_post = NewsPost.new(published: true)
    end

    def create
      @news_post = NewsPost.new(news_post_params)
      if @news_post.save
        redirect_to admin_news_posts_path, notice: "News update saved."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @news_post.update(news_post_params)
        redirect_to admin_news_posts_path, notice: "News update saved."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @news_post.destroy
      redirect_to admin_news_posts_path, notice: "News update deleted."
    end

    def publish
      @news_post.update!(published: true, published_at: Time.current)
      redirect_to admin_news_posts_path, notice: "News update published on the homepage."
    end

    private

    def set_news_post
      @news_post = NewsPost.find(params[:id])
    end

    def news_post_params
      params.require(:news_post).permit(:title, :slug, :excerpt, :body, :published, :published_at)
    end
  end
end
