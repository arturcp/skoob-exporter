class StatusController < ApplicationController
  def show
    user = SkoobUser.find_by(skoob_user_id: params[:id])

    if user
      publications = user.import_status == 0 ? Publication.where(skoob_user_id: params[:id]) : []

      render json: {
        status: user.import_status,
        duplicated: user.not_imported,
        count: user.publications.count,
        total: user.publications_count,
        publications: publications
      }
    else
      render json: { status: 0, duplicated: [], count: 0, total: 0, publications: [] }
    end
  end
end
