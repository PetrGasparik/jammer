namespace :jammer do
  desc "Update data by re-scraping BTCJam"
  task update: :environment do
    User.populate!
    Loan.populate!
    User.update_cached_data!
    Loan.update_cached_data!
    Investment.update_cached_data!
    Parameter.set_last_update_time!
  end
end
