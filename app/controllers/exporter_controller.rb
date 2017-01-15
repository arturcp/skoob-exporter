class ExporterController < ApplicationController
  def show
    csv = Exporter.new(skoob_user_id).generate_csv

    send_data csv,
      type: 'text/csv; charset=utf-8; header=present',
      disposition: "attachment; filename=skoob_books_#{skoob_user_id}.csv"
  end

  private

  def valid_params
    params.permit(:id)
  end

  def skoob_user_id
    valid_params[:id]
  end
end
