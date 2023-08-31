# frozen_string_literal: true

RSpec.describe BadsecClient::Client do
  subject(:client) { described_class.new(config) }

  let(:config) { instance_double(BadsecClient::Config) }

  describe '#authenticate!' do
    context 'when connection is not authenticated' do
      it do
        connection = instance_double(BadsecClient::Connection)

        allow(BadsecClient::Connection).to receive(:new).and_return(connection)
        allow(connection).to receive(:authenticated?).and_return(false)
        allow(connection).to receive(:authenticate!)

        client.authenticate!

        expect(connection).to have_received(:authenticate!)
      end
    end

    context 'when connection is already authenticated' do
      it do
        connection = instance_double(BadsecClient::Connection)

        allow(BadsecClient::Connection).to receive(:new).and_return(connection)
        allow(connection).to receive(:authenticated?).and_return(true)
        allow(connection).to receive(:authenticate!)

        client.authenticate!

        expect(connection).not_to have_received(:authenticate!)
      end
    end
  end

  describe '#users' do
    context 'when connection is not authenticated' do
      it do
        connection = instance_double(BadsecClient::Connection)

        allow(BadsecClient::Connection).to receive(:new).and_return(connection)
        allow(connection).to receive(:authenticated?).and_return(false)

        expect { client.users }.to raise_exception(BadsecClient::AuthenticationError)
                               .with_message('Please #authenticate! first to obtain the access_token')
      end
    end

    context 'when connection is authenticated' do
      it do
        connection = instance_double(BadsecClient::Connection)

        allow(BadsecClient::Connection).to receive(:new).and_return(connection)
        allow(connection).to receive(:authenticated?).and_return(true)

        expect(client.users).to be_a(BadsecClient::Resources::User)
      end
    end
  end
end
