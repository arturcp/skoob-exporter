class SkoobImporterWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'skoob_importer'
  sidekiq_options retry: false

  def perform(skoob)
    skoob.fetch_books!
  end
end
