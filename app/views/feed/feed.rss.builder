xml.instruct!

xml.rss :version => "2.0", "xmlns:dc" => "http://purl.org/dc/elements/1.1/" do
  xml.channel do
    xml.title CONFIG["author"]
    xml.description CONFIG["description"]
    xml.language I18n.locale.to_s
    xml.link articles_url

    @articles.each do |article|
      xml.item do
        xml.title article.title
        xml.pubDate article.published_at.to_s(:rfc822)
        xml.link article_path(article.year, article.month, article.day, article.slug)
        xml.guid article_url(article.year, article.month, article.day, article.slug), :isPermalink => true
        xml.creator article.user.name

        xml.description do
          xml.cdata! simple_format(article.resume)
        end
      end
    end
  end
end
