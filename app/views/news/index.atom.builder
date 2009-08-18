atom_feed do |feed|
  feed.title("HHLC News")
  feed.updated(@news.first ? @news.first.created_at : Time.now.utc)
  feed.logo("/images/hhlinuxclub_logo.png")
  feed.rights("All content is published under a Creative Commons BY-NC-SA 3.0 License")
  feed.generator("Eish!", :uri=> "http://hhlc.lighthouseapp.com/projects/22644-hhlc")
  
  feed.author do |author|
    author.name("Haaga-Helia Linux Club")
    author.email("general@hhlinuxclub.org")
    author.uri("http://www.hhlinuxclub.org/")
  end
 
  for news_article in @news
    feed.entry(news_article) do |entry|
      entry.title(news_article.title)
      entry.content :type => "xhtml" do |xhtml|
        xhtml << textilize(news_article.body)
      end
       
      entry.author do |author|
        author.name(news_article.user.name)
      end
    end
  end
end
