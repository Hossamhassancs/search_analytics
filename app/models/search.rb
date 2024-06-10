class Search < ApplicationRecord
  scope :completed, -> { where('LENGTH(query) > 2') } # Example condition for completed search

  before_create :remove_incomplete_searches

  private

  def remove_incomplete_searches
    Search.where(ip_address: ip_address).where('LENGTH(query) < LENGTH(?)', query).destroy_all
  end
end
  