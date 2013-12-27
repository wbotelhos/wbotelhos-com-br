require 'spec_helper'

describe Lab do
  it 'has a valid factory' do
    expect(FactoryGirl.build :lab).to be_valid
  end

  it { should validate_presence_of :description }
  it { should validate_presence_of :keywords }
  it { should validate_presence_of :title }
  it { should validate_presence_of :version }

  context :uniqueness do
    let(:lab) { FactoryGirl.create :lab }

    it 'does not allow the same title'  do
      expect(FactoryGirl.build(:lab, title: lab.title)).to be_invalid
    end
  end

  describe :scope do
    let!(:lab_1) { FactoryGirl.create :lab, created_at: Time.local(2000, 1, 1), published_at: Time.local(2001, 1, 2) }
    let!(:lab_2) { FactoryGirl.create :lab, created_at: Time.local(2000, 1, 2), published_at: Time.local(2001, 1, 1) }

    describe :home_selected do
      let!(:lab) { FactoryGirl.create :lab }
      let(:result)   { Lab.home_selected.first }

      it 'brings only the fields used on home' do
        expect(result).to     have_attribute :published_at
        expect(result).to     have_attribute :slug
        expect(result).to     have_attribute :title
        expect(result).to_not have_attribute :body
        expect(result).to_not have_attribute :created_at
        expect(result).to_not have_attribute :css_import
        expect(result).to_not have_attribute :id
        expect(result).to_not have_attribute :js
        expect(result).to_not have_attribute :js_import
        expect(result).to_not have_attribute :js_ready
        expect(result).to_not have_attribute :updated_at
        expect(result).to_not have_attribute :user_id
        expect(result).to_not have_attribute :version
      end
    end

    describe :by_month do
      let!(:lab_1) { FactoryGirl.create :lab, published_at: Time.local(2013, 01, 01) }
      let!(:lab_2) { FactoryGirl.create :lab, published_at: Time.local(2013, 01, 01) }
      let!(:lab_3) { FactoryGirl.create :lab, published_at: Time.local(2013, 02, 01) }
      let!(:lab_4) { FactoryGirl.create :lab, published_at: Time.local(2013, 03, 01) }
      let(:result) { Lab.by_month }

      xit 'groups the labs by published month'
    end

    context :sort do
      describe :by_created do
        it 'sort by created_at desc' do
          expect(Lab.by_created).to eq [lab_2, lab_1]
        end
      end

      describe :by_published do
        it 'sort by published_at desc' do
          expect(Lab.by_published).to eq [lab_1, lab_2]
        end
      end
    end

    context :state do
      let!(:lab_draft) { FactoryGirl.create :lab }

      describe :drafts do
        it 'returns drafts' do
          expect(Lab.drafts).to eq [lab_draft]
        end
      end

      describe :published do
        context 'lab without published date on the past' do
          it 'is ignored' do
            expect(Lab.published).to include lab_1, lab_2
          end
        end

        context 'lab without published date in the same time' do
          before do
            Time.stub(:now).and_return Time.local(2013, 1, 1, 0, 0, 0)

            @lab_now = FactoryGirl.create :lab, published_at: Time.now
          end

          it 'is ignored' do
            expect(Lab.published).to include @lab_now
          end
        end

        context 'lab without published date' do
          it 'is ignored' do
            expect(Lab.published).to_not include lab_draft
          end
        end

        context 'lab with published date but in the future (scheduled)' do
          let!(:lab_scheduled) { FactoryGirl.create :lab, published_at: Time.local(2500, 1, 1) }

          it 'is ignored' do
            expect(Lab.published).to_not include lab_scheduled
          end
        end
      end
    end
  end

  describe '.url' do
    let(:lab) { FactoryGirl.build :lab }

    it 'return the online url of the url' do
      expect(lab.url).to eq "#{CONFIG['url_http']}/#{lab.slug}"
    end
  end

  describe '.github' do
    let(:lab) { FactoryGirl.build :lab }

    it 'return the online url of the github' do
      expect(lab.github).to eq "#{CONFIG['github']}/#{lab.slug}"
    end
  end

  describe '.download' do
    let(:lab) { FactoryGirl.build :lab }

    it 'return the github download url' do
      expect(lab.download).to eq "#{CONFIG['github']}/#{lab.slug}/archive/#{lab.version}.zip"
    end
  end

  describe '.javascripts', :focus do
    context 'with single file' do
      let(:lab) { FactoryGirl.build :lab, js_import: 'http://example.org' }

      it 'returns the urls wrapped with script tag' do
        expect(lab.javascripts).to eq %(<script src="http://example.org"></script>)
      end
    end

    context 'with multiple files' do
      context 'with spaces' do
        let(:lab) { FactoryGirl.create :lab, js_import: 'http://example.org, http://example.com' }

        it 'returns the urls wrapped with script tag' do
          expect(lab.javascripts).to eq %(<script src="http://example.org"></script><script src="http://example.com"></script>)
        end
      end

      context 'without spaces' do
        let(:lab) { FactoryGirl.build :lab, js_import: 'http://example.org,http://example.com' }

        it 'returns the urls wrapped with script tag' do
          expect(lab.javascripts).to eq %(<script src="http://example.org"></script><script src="http://example.com"></script>)
        end
      end
    end
  end

  describe '.stylesheets', :focus do
    context 'with single file' do
      let(:lab) { FactoryGirl.build :lab, css_import: 'http://example.org' }

      it 'returns the urls wrapped with link tag' do
        expect(lab.stylesheets).to eq %(<link rel="stylesheet" href="http://example.org">)
      end
    end

    context 'with multiple files' do
      context 'with spaces' do
        let(:lab) { FactoryGirl.create :lab, css_import: 'http://example.org, http://example.com' }

        it 'returns the urls wrapped with link tag' do
          expect(lab.stylesheets).to eq %(<link rel="stylesheet" href="http://example.org"><link rel="stylesheet" href="http://example.com">)
        end
      end

      context 'without spaces' do
        let(:lab) { FactoryGirl.build :lab, css_import: 'http://example.org,http://example.com' }

        it 'returns the urls wrapped with link tag' do
          expect(lab.stylesheets).to eq %(<link rel="stylesheet" href="http://example.org"><link rel="stylesheet" href="http://example.com">)
        end
      end
    end
  end
end
