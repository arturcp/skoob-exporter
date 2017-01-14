class CrawlersController < ApplicationController
  def index
  end

  def create
    Skoob.new(params[:email], params[:password]).fetch_books!
    redirect_to crawler_path(1)
  end

  def show
  end
end
