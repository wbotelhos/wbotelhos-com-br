class SidebarPresenter

  def admin
    { :partial => "sidebar/admin" }
  end

  def articles
    articles = Article.select("id, title").all

    { :partial => "sidebar/articles", :locals => { :articles => articles } }
  end

  def categories
    categories = Category.scoped

    { :partial => "sidebar/categories", :locals => { :categories => categories } }
  end

  def links
    links = Link.scoped

    { :partial => "sidebar/links", :locals => { :links => links } }
  end

end
