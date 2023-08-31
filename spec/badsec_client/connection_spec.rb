# frozen_string_literal: true

RSpec.describe BadsecClient::Connection do
  subject(:connection) { described_class.new(config) }

  let(:config) { OpenStruct.new(host: 'example.com', max_failure_retry_attempts: 2) }

  describe '#authenticated?' do
    it { expect(connection.authenticated?).to be_falsey }
  end

  describe '#authenticate!' do
    context 'when response is a success' do
      it do
        response = instance_double(
          Faraday::Response, status: 200, headers: { 'badsec-authentication-token' => 'X-Y-Z' }
        )
        allow(Faraday).to receive(:head).with('http://example.com/auth').and_return(response)

        connection.authenticate!

        expect(connection.access_token).to eq('X-Y-Z')
        expect(connection.authenticated?).to be_truthy
      end
    end

    context 'when response is a failure' do
      it do
        response = instance_double(
          Faraday::Response, status: 400, headers: {}, body: 'Something went wrong'
        )
        allow(Faraday).to receive(:head).with('http://example.com/auth').and_return(response)

        expect { connection.authenticate! }.to raise_exception(BadsecClient::MaxRetryExceededError)
          .with_message('Max retry threshold reached')

        expect(connection.access_token).to be_nil
        expect(connection.authenticated?).to be_falsey
      end
    end
  end

  describe '#get' do
    let(:resource_name) { 'books' }

    context 'when request checksum is given' do
      let(:request_checksum) { 'checksum123' }

      it do
        response = instance_double(
          Faraday::Response, status: 200, headers: { 'badsec-authentication-token' => 'X-Y-Z' }
        )
        allow(Faraday).to receive(:get).with(
          'http://example.com/books', {}, { 'X-Request-Checksum' => request_checksum }
        ).and_return(response)

        connection.get(resource_name:, request_checksum:)
      end
    end

    context 'when request checksum is not given' do
      let(:request_checksum) { nil }

      it do
        response = instance_double(
          Faraday::Response, status: 200, headers: { 'badsec-authentication-token' => 'X-Y-Z' }
        )
        allow(Faraday).to receive(:get).with('http://example.com/books', {}, {}).and_return(response)

        connection.get(resource_name:, request_checksum:)
      end
    end
  end
end
