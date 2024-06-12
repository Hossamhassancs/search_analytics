class SearchesController < ApplicationController
  before_action :set_user_ip_address

  def index
    @top_searches = my_top_search_terms
  end

  def create
    query = params[:query]
    LogSearchJob.perform_later(query, @user_ip) if query.present?

    head :ok
  end

  def top_searches
    top_searches = my_top_search_terms
    render json: top_searches
  end

  private

  def my_top_search_terms
    Rails.cache.fetch("my_top_searches_#{@user_ip}", expires_in: 20.seconds) do
      Search.where(ip_address: @user_ip).group(:query).order('count_id DESC').count(:id)
    end
  end

  def set_user_ip_address
    @user_ip = request.remote_ip
  end
end
