class LogSearchJob < ApplicationJob
  queue_as :default
  
  def perform(query, ip_address)
    Search.create(query: query, ip_address: ip_address)
  end
end
  