# frozen_string_literal: true

RSpec.describe BadsecClient do
  describe '.run' do
    context 'when no exceptions are raised' do
      it do
        client = instance_double(BadsecClient::Client)
        allow(BadsecClient::Client).to receive(:new).and_return(client)
        allow(client).to receive(:authenticate!)

        user_resource = instance_double(BadsecClient::Resources::User)
        allow(client).to receive(:users).and_return(user_resource)
        allow(user_resource).to receive(:list).and_return(%w[1 2 3])

        expect { described_class.run }.to output('["1","2","3"]').to_stdout
      end
    end

    context 'when MaxRetryExceededError is raised' do
      it do
        client = instance_double(BadsecClient::Client)
        allow(BadsecClient::Client).to receive(:new).and_return(client)
        allow(client).to receive(:authenticate!).and_raise(BadsecClient::MaxRetryExceededError)

        expect { described_class.run }.to raise_error SystemExit
      end
    end
  end
end
