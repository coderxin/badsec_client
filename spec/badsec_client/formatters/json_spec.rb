# frozen_string_literal: true

RSpec.describe BadsecClient::Formatters::Json do
  describe '.format' do
    context 'when non-empty input is given' do
      it 'does format input as JSON' do
        input = %w[7692335473348482352 6944230214351225668 3628386513825310392]
        expect(described_class.format(input)).to eq(
          '["7692335473348482352","6944230214351225668","3628386513825310392"]'
        )
      end
    end

    context 'when empty input is given' do
      it 'does format input as JSON' do
        input = []
        expect(described_class.format(input)).to eq('[]')
      end
    end
  end
end
