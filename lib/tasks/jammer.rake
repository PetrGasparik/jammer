namespace :jammer do
  desc "Update data by re-scraping BTCJam"
  task update: :environment do
    begin
      Parameter.set_update_running!
      User.populate!
      Loan.populate!
      User.update_cached_data!
      Loan.update_cached_data!
      Investment.update_cached_data!
      Parameter.set_last_update_time!
    rescue
      Parameter.set_update_failed!
      raise
    end
  end
end
