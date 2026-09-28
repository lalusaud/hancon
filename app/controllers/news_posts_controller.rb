class NewsPostsController < ApplicationController
  allow_unauthenticated_access

  def show
    @news_post = NewsPost.published.find_by!(slug: params[:slug])
  end
end
