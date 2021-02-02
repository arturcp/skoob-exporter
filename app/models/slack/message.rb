# frozen_string_literal: true

module Slack
  class Message
    def self.send(message, notify_channel: false, url: nil)
      webhook = ENV['SLACK_WEBHOOK']
      return unless webhook.present?

      notifier = Slack::Notifier.new(webhook)
      message = "<!channel> #{message}" if notify_channel
      message = "[#{message}](#{url})" if url
      notifier.ping(message)
    end
  end
end
