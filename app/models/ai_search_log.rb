class AiSearchLog < ApplicationRecord
  def self.can_search?(ip_address:)
    return false if ip_address.nil?

    where(ip_address: ip_address)
      .where('created_at > ?', 1.hour.ago)
      .count < AI_SEARCH_CONFIG[:hourly_limit]
  end

  def self.remaining_searches(ip_address:)
    return 0 if ip_address.nil?

    count = where(ip_address: ip_address)
              .where('created_at > ?', 1.hour.ago)
              .count

    [AI_SEARCH_CONFIG[:hourly_limit] - count, 0].max
  end

  def self.log_rate_limit_exceeded(ip_address)
    now  = Time.current
    from = 1.hour.ago
    logs = where(ip_address: ip_address).where(created_at: from..now).order(:created_at)
    count = logs.count

    avg = if count > 1
            (logs.last.created_at - logs.first.created_at) / (count - 1)
          else
            0
          end

    AI_SEARCH_LOGGER.info <<~LOG
      RATE LIMIT EXCEEDED
      IP: #{ip_address}
      Window: #{from} → #{now}
      Requests in window: #{count}/#{AI_SEARCH_CONFIG[:hourly_limit]}
      Average interval: #{avg.round(2)} sec
      ---
    LOG
  end
end
