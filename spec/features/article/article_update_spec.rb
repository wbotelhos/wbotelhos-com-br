# frozen_string_literal: true

require 'support/capybara_box'
require 'support/includes/login'

RSpec.describe Article, '#update' do
  let(:article) { FactoryBot.create :article }
  let!(:user) { FactoryBot.create(:user) }

  before do
    login(user)
    visit edit_article_path article
  end

  it 'shows the preview link' do
    expect(page).to have_link 'Preview', href: slug_path(article.slug)
  end

  context 'with valid data' do
    before do
      fill_in 'article_title', with: 'Some Title'
      fill_in 'article_body', with: 'Some body'

      click_button 'Atualizar'
    end

    it 'redirects to edit page' do
      expect(page).to have_current_path "/articles/#{article.id}/edit"
    end

    it { expect(find_field('article_title').value).to eq 'Some Title' }
    it { expect(find_field('article_body').value).to  eq 'Some body' }
  end

  context 'with invalid data', :js do
    context 'blank title' do
      before do
        page.execute_script "$('#article_title').removeAttr('required');"

        fill_in 'article_title', with: ''

        click_button 'Atualizar'
      end

      it 'renders form page again' do
        expect(page).to have_current_path article_path article
      end

      it { expect(page).to have_content 'O campo "Título" deve ser preenchido!' }
    end
  end

  context 'when unpublished' do
    it 'shows the publish button' do
      expect(page).to have_button 'Publicar'
    end

    context 'and click on publish button' do
      before do
        visit edit_article_path article

        click_button 'Publicar'
      end

      it 'renders index page' do
        expect(page).to have_current_path root_path
      end

      it 'shows the actual article on published list' do
        expect(page).to have_content article.title
      end
    end
  end

  context 'when published' do
    before do
      article.publish!

      visit edit_article_path article
    end

    it 'hides the publish button' do
      expect(page).not_to have_button 'Publicar'
    end
  end
end
