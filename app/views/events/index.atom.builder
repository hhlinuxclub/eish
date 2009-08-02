atom_feed do |feed|
  feed.title("HHLC Upcoming Events")
  feed.updated(@latest_update)
  feed.logo("/images/hhlinuxclub_logo.png")
  feed.rights("All content is published under a Creative Commons BY-NC-SA 3.0 License")
  feed.generator("Eish!", :uri=> "http://hhlc.lighthouseapp.com/projects/22644-hhlc")
  
  feed.author do |author|
    author.name("Haaga-Helia Linux Club")
    author.email("general@hhlinuxclub.org")
    author.uri("http://www.hhlinuxclub.org/")
  end
  
  for event in @upcoming_events
    feed.entry(event, :url => event_path(event, :format => nil)) do |entry|
      entry.title(event.name + " [" + long_date(event.starts_at) + "]")
      entry.content(event.description, :type => 'html')
       
      entry.author do |author|
        author.name(event.user.first_name + " " + event.user.last_name)
      end
    end
  end
end
