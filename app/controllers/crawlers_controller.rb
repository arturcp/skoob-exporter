class CrawlersController < ApplicationController
  def index
  end

  def create
    user = SkoobUser.login(params[:email], params[:password])

    if user.skoob_user_id > 0
      user.update(import_status: 1)
      SkoobImporterWorker.perform_async(user.skoob_user_id)

      redirect_to crawler_path(user.skoob_user_id)
    else
      flash[:error] = 'Invalid Credentials'
      redirect_to root_path
    end
  end

  def show
    @user = SkoobUser.find_by(skoob_user_id: params[:id])
  end
end
