class SearchesController < ApplicationController

  def index
    @top_searches = top_search_terms
  end

  def create
    query = params[:query]
    ip_address = request.remote_ip

    Search.create(query: query, ip_address: ip_address)
    head :ok
  end

  def top_searches
    top_searches = top_search_terms
    render json: top_searches
  end

  private

  def top_search_terms
    Search.group(:query).order('count_id DESC').count(:id)
  end

end
