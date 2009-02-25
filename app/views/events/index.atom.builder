atom_feed do |feed|
  feed.title("HHLC Upcoming Events")
  feed.updated(Time.now.utc)
 
  for event in @upcoming_events
    feed.entry(event, :url => event_url(:id => event.id, :format => nil)) do |entry|
      entry.title(event.name)
      entry.content(event.description, :type => 'html')
       
      entry.author do |author|
        author.name(event.user.first_name + " " + event.user.last_name)
      end
    end
  end
end
