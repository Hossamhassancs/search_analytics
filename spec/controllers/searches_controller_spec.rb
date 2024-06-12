require 'rails_helper'

RSpec.describe SearchesController, type: :controller do
  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end

    it 'assigns @top_searches' do
      create(:search, query: 'search term 1', ip_address: '192.168.1.1')
      create(:search, query: 'search term 2', ip_address: '192.168.1.1')
      allow_any_instance_of(ActionDispatch::Request).to receive(:remote_ip).and_return('192.168.1.1')
      get :index
      expect(assigns(:top_searches)).to eq({'search term 1' => 1, 'search term 2' => 1})
    end
  end

  describe 'POST #create' do
    it 'enqueues a LogSearchJob' do
      expect {
        post :create, params: { query: 'test query' }
      }.to have_enqueued_job(LogSearchJob)
    end

    it 'returns a success response' do
      post :create, params: { query: 'test query' }
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET #top_searches' do
    it 'returns a success response' do
      get :top_searches
      expect(response).to be_successful
    end

    it 'returns the top search terms as JSON' do
      create(:search, query: 'search term 1', ip_address: '192.168.1.1')
      create(:search, query: 'search term 2', ip_address: '192.168.1.1')
      allow_any_instance_of(ActionDispatch::Request).to receive(:remote_ip).and_return('192.168.1.1')
      get :top_searches
      json = JSON.parse(response.body)
      expect(json).to eq({'search term 1' => 1, 'search term 2' => 1})
    end
  end

  describe 'Private Methods' do
    describe '#my_top_search_terms' do
      it 'returns the top search terms for the current IP address' do
        allow_any_instance_of(ActionDispatch::Request).to receive(:remote_ip).and_return('192.168.1.1')
        create(:search, query: 'search term 1', ip_address: '192.168.1.1')
        create(:search, query: 'search term 2', ip_address: '192.168.1.1')
        result = controller.send(:my_top_search_terms)
        expect(result).to eq({'search term 1' => 1, 'search term 2' => 1})
      end
    end

    describe '#user_ip_address' do
      it 'returns the remote IP address' do
        allow_any_instance_of(ActionDispatch::Request).to receive(:remote_ip).and_return('192.168.1.1')
        expect(controller.send(:user_ip_address)).to eq('192.168.1.1')
      end
    end
  end
end
