namespace :jammer do
  desc "Update data by re-scraping BTCJam"
  task update: :environment do
    User.populate!
  end
end
