if SEARCH_ENABLED
  Xapit::Config.setup(
      :database_path => "#{Rails.root}/db/xapiandb",
      :stemming => "english"
  )
end