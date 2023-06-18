class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :force_http

  private

  def force_http
    if request.ssl?
      response.headers['Strict-Transport-Security'] = 'max-age=0; includeSubDomains'
      redirect_to protocol: 'http://', status: :moved_permanently
    end
  end
end
