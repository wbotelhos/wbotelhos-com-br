require 'spec_helper'

describe ArticleHelper do
  describe '#published_at' do
    context 'with published_at date' do
      let(:article) { FactoryGirl.build :article, published_at: Time.local(2000, 1, 1) }

      it 'returns the published date formated' do
        expect(helper.published_at article).to eq '01 de Janeiro de 2000'
      end
    end

    context 'without published_at date' do
      let(:article) { FactoryGirl.build :article, created_at: Time.local(2001, 1, 1) }

      it 'returns the created date formated' do
        expect(helper.published_at article).to eq '01 de Janeiro de 2001'
      end
    end
  end
end
