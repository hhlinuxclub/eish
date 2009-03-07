atom_feed do |feed|
  feed.title("HHLC Articles")
  feed.updated(@articles.first ? @articles.first.created_at : Time.now.utc)
 
  for article in @articles
    feed.entry(article, :url => article_details_path(:id => article.id, :title => urlify(article.title), :format => nil)) do |entry|
      entry.title(article.title)
      entry.content(article.description, :type => 'html')
       
      entry.author do |author|
        author.name(article.user.first_name + " " + article.user.last_name)
      end
    end
  end
end
