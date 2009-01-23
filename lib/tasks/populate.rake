namespace :db do
  desc "Erase and fill database with dummy data"
  task :populate => :environment do
    require 'populator'
    require 'faker'
    
    [News, Article, Event].each(&:delete_all)
    
    News.populate 20 do |news_article|
      news_article.title = Populator.words(3..7).titleize
      news_article.body = Populator.paragraphs(1..3)
      news_article.user_id = 1
      news_article.published = true
    end
    
    Article.populate 40 do |article|
      article.title = Populator.words(2..5).titleize
      article.description = Populator.words(10..20).capitalize + "."
      article.body = Populator.paragraphs(5..20)
      article.user_id = 1
      article.published = true
    end
    
    Event.populate 30 do |event|
      event.name = Populator.words(1..3).titleize
      event.starts_at = Populator.value_in_range(Time.now - 60000000..Time.now + 60000000)      
      event.ends_at = Populator.value_in_range(event.starts_at..Time.now + 500000)
      event.location = Faker::Address.street_address + ", " + Faker::Address.city
      event.is_address = true
      event.published = true
      event.description = Populator.sentences(1..5)
      event.user_id = 1
    end
  end
end