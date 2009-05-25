if SEARCH_ENABLED
  Xapit::Config.setup(
      :database_path => "#{Rails.root}/db/xapiandb",
      :stemming => "english",
      :breadcrumb_facets => true
  )
end