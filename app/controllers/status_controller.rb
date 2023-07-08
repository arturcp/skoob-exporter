class StatusController < ApplicationController
  def show
    user = SkoobUser.find_by(skoob_user_id: params[:id])

    if user
      books = user.import_status == 0 ? Book.where(skoob_user_id: params[:id]) : []

      render json: {
        status: user.import_status,
        duplicated: user.not_imported,
        count: user.books.count,
        total: user.books_count,
        books: books
      }
    else
      render json: { status: 0, duplicated: [], count: 0, total: 0, books: [] }
    end
  end
end
