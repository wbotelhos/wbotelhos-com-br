# coding: utf-8

require 'spec_helper'

describe Lab, '#show' do
  let(:lab) { FactoryGirl.create :lab_published }

  before { visit slug_path lab.slug }

  it 'redirects to show page' do
    expect(current_path).to eq "/#{lab.slug}"
  end

  it 'does not display edit link' do
    within 'header' do
      expect(page).to_not have_link 'Editar'
    end
  end

  describe 'header' do
    it 'shows title' do
      within '.header' do
        expect(page).to have_link lab.title, href: slug_path(lab.slug)
      end
    end

    it 'shows description' do
      within '.header' do
        expect(page).to have_link lab.description
      end
    end
  end

  describe 'navigation' do
    it 'shows download button' do
      within 'nav' do
        expect(page).to have_link "v#{lab.version}", href: "#{CONFIG['github']}/#{lab.slug}/archive/#{lab.version}.zip"
      end
    end

    it 'show github button' do
      within 'nav' do
        expect(page).to have_link '', href: "#{CONFIG['github']}/#{lab.slug}"
      end
    end

    it 'show labs button' do
      within 'nav' do
        expect(page).to have_link '', href: "#{CONFIG['url_http']}/labs"
      end
    end

    context 'donate icon' do
      it 'shows donate icon' do
        expect(page).to have_css '.i-heart'
      end

      it 'hides donate options' do
        expect(page).to have_link 'Git tip' , visible: false
        expect(page).to have_link 'Paypal'  , visible: false
      end

      context 'clicking on donate icon' do
        before { find('.i-heart').click }

        it 'shows donate options' do
          expect(page).to have_link 'Git tip' , visible: true
          expect(page).to have_link 'Paypal'  , visible: true
        end

        context 'clicking again' do
          before { find('.i-heart').click }

          it 'hides donate options' do
            expect(page).to have_link 'Git tip' , visible: false
            expect(page).to have_link 'Paypal'  , visible: false
          end
        end
      end
    end
  end

  context 'when logged' do
    before do
      login
      visit slug_path lab.slug
    end

    it 'displays edit link' do
      within 'header' do
        expect(page).to have_link 'Editar', href: edit_lab_path(lab)
      end
    end
  end
end
