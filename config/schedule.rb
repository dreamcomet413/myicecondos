every 1.day, :at => '5:00 am' do
  runner "Sync.nightly_listing_sync"
end
