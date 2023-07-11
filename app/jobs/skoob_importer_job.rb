class SkoobImporterJob < ActiveJob::Base
  queue_as :default

  sidekiq_options retry: 0, dead: false

  def perform(user)
    Skoob.fetch_publications!(user) if user
  end
end
