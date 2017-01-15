class SkoobImporterWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'skoob_importer'
  sidekiq_options retry: false

  def perform(skoob_user_id)
    user = SkoobUser.find_by(skoob_user_id: skoob_user_id)

    Skoob.fetch_books!(user)
  end
end
