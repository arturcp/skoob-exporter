class ExporterController < ApplicationController
  def show
    csv = Exporter.new(skoob_user_id).generate_csv
    send_slack_notification(csv)

    Book.where(skoob_user_id: skoob_user_id).destroy_all

    file_name = "skoob_books_#{skoob_user_id}.csv"

    # Set the response headers
    headers['Content-Disposition'] = "attachment; filename=\"#{file_name}\""
    headers['Content-Type'] = 'text/csv'

    send_data csv, filename: file_name, type: "text/csv", disposition: "attachment"
  end

  private

  def valid_params
    params.permit(:id)
  end

  def skoob_user_id
    valid_params[:id]
  end

  def send_slack_notification(csv)
    books = csv.split("\n").length - 1
    message = "User #{skoob_user_id} has just exported #{books} books from Skoob!"
    Slack::Message.send(message, notify_channel: true)
  end
end
