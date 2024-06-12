class SearchesController < ApplicationController
  before_action :user_ip_address

  def index
    @top_searches = my_top_search_terms
  end

  def create
    query = params[:query]
    ip_address = request.remote_ip

    if query.present?
      LogSearchJob.perform_later(query, ip_address)
    end

    head :ok
  end

  def top_searches
    top_searches = my_top_search_terms
    render json: top_searches
  end

  private

  def my_top_search_terms
    Rails.cache.fetch('my_top_searches', expires_in: 1.minutes) do
      Search.where(ip_address: user_ip_address).group(:query).order('count_id DESC').count(:id)
    end
  end

  def user_ip_address
    request.remote_ip
  end
end
