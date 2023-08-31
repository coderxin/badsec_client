# frozen_string_literal: true

RSpec.describe BadsecClient::Config do
  subject(:config) { described_class.new }

  describe '#host' do
    it { expect(config.host).to eq('localhost:8888') }
  end

  describe '#max_failure_retry_attempts' do
    it { expect(config.max_failure_retry_attempts).to eq(2) }
  end
end
