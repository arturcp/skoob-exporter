class CrawlersController < ApplicationController
  def index; end

  def create
    user = SkoobUser.login(params[:email], params[:password])

    if user.skoob_user_id > 0
      Publication.where(skoob_user_id: user.skoob_user_id).destroy_all

      user.update(import_status: 1)
      SkoobImporterJob.perform_later(user)
      send_slack_notification(user.skoob_user_id)

      redirect_to crawler_path(user.skoob_user_id)
    else
      flash[:error] = 'Invalid Credentials'
      redirect_to root_path
    end
  end

  def show
    @user = SkoobUser.find_by(skoob_user_id: params[:id])

    if @user.import_status == 0 && Publication.where(skoob_user_id: @user.skoob_user_id).count == 0
      redirect_to root_path
    end
  end

  private

  def send_slack_notification(skoob_user_id)
    message = "User https://www.skoob.com.br/usuario/#{skoob_user_id} is importing..."
    Slack::Message.send(message)
  end
end
