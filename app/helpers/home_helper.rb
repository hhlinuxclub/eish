module HomeHelper
  def same_time_distance?(collection, index)
    time_ago_in_words(collection[index].published_at) != time_ago_in_words(collection[index-1].published_at) || index == 0
  end
end
