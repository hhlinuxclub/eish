atom_feed do |feed|
  feed.title("HHLC News")
  feed.updated(@news.first ? @news.first.created_at : Time.now.utc)
 
  for news_article in @news
    feed.entry(news_article, :url => news_article_details_path(:id => news_article.id, :title => urlify(news_article.title),:format => nil)) do |entry|
      entry.title(news_article.title)
      entry.content(news_article.body, :type => 'html')
       
      entry.author do |author|
        author.name(news_article.user.first_name + " " + news_article.user.last_name)
      end
    end
  end
end
