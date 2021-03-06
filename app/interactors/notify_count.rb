class NotifyCount
  include Interactor

  delegate :bucket, :email, to: :context
  delegate :token, to: :bucket

  def call
    return unless ENV['PUSHER_URL']

    channel = Pusher["channel_emails_#{token}"]

    channel.trigger(
      'update_count',
      emails_count: bucket.emails_count,
      email: SimpleEmailSerializer.new(email)
    )
  rescue => e
    Rails.logger.error(e)
  end
end
