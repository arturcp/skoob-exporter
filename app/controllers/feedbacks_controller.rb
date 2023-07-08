# frozen_string_literal: true

class FeedbacksController < ApplicationController
  def create
    messages = []
    messages << 'New feedback received: '
    messages << feedback_params[:name] if feedback_params[:name].present?
    messages << "<#{feedback_params[:email]}>" if feedback_params[:email].present?
    messages << " ```#{feedback_params[:message]}```"
    Slack::Message.send(messages.join(' '), notify_channel: true)
  end

  private

  def feedback_params
    params.require(:feedback).permit(:name, :email, :message)
  end
end
