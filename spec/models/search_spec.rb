require 'rails_helper'

RSpec.describe Search, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:query) }
    it { should validate_presence_of(:ip_address) }
  end

  describe 'before_create callback' do
    it 'removes incomplete searches with the same IP address' do
      complete_search = create(:search, query: 'example query', ip_address: '192.168.1.1')
      incomplete_search1 = create(:search, query: 'example', ip_address: '192.168.1.1')
      incomplete_search2 = create(:search, query: 'example q', ip_address: '192.168.1.1')

      new_search = build(:search, query: 'example query', ip_address: '192.168.1.1')
      expect { new_search.save }.to change { Search.count }.by(0)

      expect(Search.exists?(incomplete_search1.id)).to be_falsey
      expect(Search.exists?(incomplete_search2.id)).to be_falsey
      expect(Search.exists?(complete_search.id)).to be_truthy
    end
  end
end
