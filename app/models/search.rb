class Search < ApplicationRecord
  validates_presence_of :query, :ip_address

  before_create :remove_incomplete_searches

  private

  def remove_incomplete_searches
    Search.where(ip_address: ip_address)
          .where('LENGTH(query) < LENGTH(?) AND ? LIKE \'%\' || query || \'%\'', query, query).destroy_all
  end
end