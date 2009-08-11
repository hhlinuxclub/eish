atom_feed do |feed|
  feed.title("HHLC Articles")
  feed.updated(@articles.first ? @articles.first.created_at : Time.now.utc)
  feed.logo("/images/hhlinuxclub_logo.png")
  feed.rights("All content is published under a Creative Commons BY-NC-SA 3.0 License")
  feed.generator("Eish!", :uri=> "http://hhlc.lighthouseapp.com/projects/22644-hhlc")
  
  feed.author do |author|
    author.name("Haaga-Helia Linux Club")
    author.email("general@hhlinuxclub.org")
    author.uri("http://www.hhlinuxclub.org/")
  end
 
  for article in @articles
    feed.entry(article) do |entry|
      entry.title(article.title)
      entry.content(article.description, :type => 'html')
       
      entry.author do |author|
        author.name(article.user.first_name + " " + article.user.last_name)
      end
    end
  end
end
