require 'rails_helper'

RSpec.describe LoadbalancerService do
  let(:fake_server_list) { { 'server-1' => 'http://server-1-url.com', 'server-2' => 'http://server-2-url.com' } }

  before do
    allow(described_class).to receive(:fetch_servers).and_return(fake_server_list)
    allow(described_class).to receive(:server_names).and_return(fake_server_list.keys)
    allow(described_class).to receive(:server_count).and_return(fake_server_list.keys.length)
  end

  context 'when we call loadbalancer iteratively' do
    it 'cycles through servers in a cyclical manner' do
      expect(described_class.call).to eq('http://server-1-url.com')
      expect(described_class.call).to eq('http://server-2-url.com')
      expect(described_class.call).to eq('http://server-1-url.com')
    end
  end
end
