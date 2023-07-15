# frozen_string_literal: true

RSpec.describe Slack::Message, type: :model do
  describe '.send' do
    context 'when the webhook is present' do
      let(:webhook) { 'https://hooks.slack.com/services/123' }
      let(:notifier) { double('Notifier') }
      let(:message) { 'message' }
      let(:url) { 'url' }

      before do
        allow(ENV).to receive(:[]).with('SLACK_WEBHOOK').and_return(webhook)
        allow(SlackNotify::Client).to receive(:new).with(webhook_url: webhook).and_return(notifier)
        allow(notifier).to receive(:notify)
      end

      it 'sends the message' do
        expect(notifier).to receive(:notify).with(message, '#skoob-exporter')

        Slack::Message.send(message)
      end

      context 'when the notify_channel option is true' do
        it 'notifies the channel' do
          expect(notifier).to receive(:notify).with("<!channel> #{message}", '#skoob-exporter')

          Slack::Message.send(message, notify_channel: true)
        end
      end

      context 'when the url option is present' do
        it 'sends the message with the URL' do
          expect(notifier).to receive(:notify).with("[#{message}](#{url})", '#skoob-exporter')

          Slack::Message.send(message, url: url)
        end
      end
    end

    context 'when the webhook is not present' do
      before { allow(ENV).to receive(:[]).with('SLACK_WEBHOOK').and_return(nil) }

      it 'does not send the message' do
        expect(SlackNotify::Client).not_to receive(:new)

        Slack::Message.send('message')
      end
    end
  end
end
