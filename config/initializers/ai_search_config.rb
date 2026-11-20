AI_SEARCH_CONFIG = {
  hourly_limit: Rails.env.development? ? 3 : 15,
  query_max_length: 500,
  request_timeout: 10
}.freeze


AI_SEARCH_LOGGER = Logger.new(Rails.root.join("log/ai_search.log"))
AI_SEARCH_LOGGER.level = Logger::INFO
