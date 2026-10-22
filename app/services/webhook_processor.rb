require "openssl"

class WebhookProcessor
  class InvalidSignature < StandardError; end
  class InvalidPayload < StandardError; end

  def self.call(webhook, request)
    new(webhook, request).call
  end

  def initialize(webhook, request)
    @webhook = webhook
    @request = request
  end

  def call
    verify_signature!

    payload = JSON.parse(@request.raw_post)
    raise InvalidPayload unless payload.is_a?(Hash)

    if @webhook.provider == "github"
      event = @request.headers["X-GitHub-Event"]
      delivery_id = @request.headers["X-GitHub-Delivery"]
    else
      event = @request.headers["X-Gitlab-Event"]
      delivery_id = @request.headers["webhook-id"].presence ||
        @request.headers["Idempotency-Key"]
    end

    raise InvalidPayload if event.blank? || delivery_id.blank?

    @webhook.webhook_events.create_or_find_by!(delivery_id: delivery_id) do |record|
      record.event = event
      record.summary = summarize(payload, event)
    end
  end

  private

  def verify_signature!
    raise InvalidSignature if @webhook.secret.blank?

    case @webhook.provider
    when "github"
      supplied = @request.headers["X-Hub-Signature-256"]
      expected = "sha256=" + OpenSSL::HMAC.hexdigest(
        "SHA256", @webhook.secret, @request.raw_post
      )
    when "gitlab"
      supplied = @request.headers["X-Gitlab-Token"]
      expected = @webhook.secret
    else
      raise InvalidSignature
    end

    raise InvalidSignature unless supplied.present? &&
      ActiveSupport::SecurityUtils.secure_compare(expected, supplied)
  end

  def summarize(payload, event)
    actor = text_at(payload, "sender", "login") ||
      text_at(payload, "user", "username") ||
      text_at(payload, "user_name") || "Unknown github user"
    repository = text_at(payload, "repository", "full_name") ||
      text_at(payload, "project", "path_with_namespace") || @webhook.name
    action = text_at(payload, "action") ||
      text_at(payload, "object_attributes", "action")
    title = text_at(payload, "pull_request", "title") ||
      text_at(payload, "issue", "title") ||
      text_at(payload, "object_attributes", "title")

    [actor, event, action, title, repository].compact.join(" · ").truncate(500)
  end

  def text_at(payload, *keys)
    value = keys.reduce(payload) do |current, key|
      current.is_a?(Hash) ? current[key] : nil
    end
    value.presence if value.is_a?(String)
  end
end
