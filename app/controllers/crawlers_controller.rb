class CrawlersController < ApplicationController
  def index
  end

  def create
    skoob = Skoob.new(params[:email], params[:password])
    if skoob.user.skoob_user_id > 0
      # SkoobImporterWorker.perform_async(skoob)
      redirect_to crawler_path(skoob.user.skoob_user_id)
    else
      flash[:error] = 'Invalid Credentials'
      redirect_to root_path
    end
  end

  def show
    @user = SkoobUser.find_by(skoob_user_id: params[:id])
  end
end
