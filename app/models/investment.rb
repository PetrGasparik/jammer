class Investment < ActiveRecord::Base
  belongs_to :user
  belongs_to :loan
  validates :loan_id, :presence => true
  validates :user_id, :presence => true

  def self.update_cached_data!
    Investment.all.each do |investment|
      investment.state = investment.loan.state
      investment.user_name = investment.user.nil? ? nil : investment.user.alias
      investment.loan_name = investment.loan.name
      investment.borrower_name = investment.loan.user.nil? ? nil : investment.loan.user.alias
      investment.save!
    end
  end
end
