# frozen_string_literal: true

require 'digest'

RSpec.describe BadsecClient::Resources::User do
  subject(:resource) { described_class.new(connection) }

  let(:connection) { instance_double(BadsecClient::Connection) }
  let(:request_checksum) { Digest::SHA256.hexdigest('X-Y-Z/users') }
  let(:resource_name) { 'users' }

  describe '#list' do
    context 'when response body does contain 64-bit newline-separated user IDs' do
      it do
        response = OpenStruct.new(body: "18207056982152612516\n7692335473348482352\n6944230214351225668")

        allow(connection).to receive(:access_token).and_return('X-Y-Z')
        allow(connection).to receive(:get).with(resource_name:, request_checksum:).and_return(response)

        expect(resource.list).to eq(%w[18207056982152612516 7692335473348482352 6944230214351225668])
      end
    end

    context 'when response body is empty' do
      it do
        response = OpenStruct.new(body: '')

        allow(connection).to receive(:access_token).and_return('X-Y-Z')
        allow(connection).to receive(:get).with(resource_name:, request_checksum:).and_return(response)

        expect(resource.list).to be_empty
      end
    end
  end
end
