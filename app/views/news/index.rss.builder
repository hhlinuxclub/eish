xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "HHLC News"
    xml.description "News articles from the HAAGA-HELIA Linux Club."
    xml.link formatted_news_url(:rss)
    
    for news_article in @news
      xml.item do
        xml.title news_article.title
        xml.description news_article.body
        xml.pubDate news_article.created_at.to_s(:rfc822)
        xml.link formatted_news_article_url(news_article, :rss)
        xml.guid formatted_news_article_url(news_article, :rss)
      end
    end
  end
end