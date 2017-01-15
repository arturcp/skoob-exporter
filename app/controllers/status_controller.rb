class StatusController < ApplicationController
  def show
    user = SkoobUser.find_by(skoob_user_id: params[:id])

    if user
      render json: { status: user.import_status, duplicated: user.not_imported, count: user.books.count }
    else
      render json: { status: 0, duplicated: [], count: 0 }
    end
  end
end
