require 'mechanize'

class User < ActiveRecord::Base
  has_many :loans

  def self.populate!
    agent = Mechanize.new
    agent.ca_file = Jammer::Application.config.ca_file

    uid = 1
    del_count = 0

    loop do
      page = agent.get("https://www.btcjam.com/users/#{uid}")

      user = User.find_by_id(uid)

      title = page.title
      if title == 'Peer to Peer Bitcoin Lending - BTCJam'
        # redirects to front page if we find a deleted user
        del_count += 1

        # assuming a row of 10 deleted users means we've run out of users. It's an unusual-enough occurrence
        break if del_count > 10
      else
        # We've found a user
        user_alias = title.sub(/ - BTCJam$/, '')

        payments_text = page.at('dt:contains("Payments Made") ~ dd').text
        payments_btc = from_btc_str(payments_text.scan(/^฿(\d+\.\d+)/).last.first)
        payments_count = payments_text.scan(/\((\d+)\)$/).last.first

        overdue_text = page.at('dt:contains("Overdue Payments") ~ dd').text
        overdue_btc = from_btc_str(overdue_text.scan(/^฿(\d+\.\d+)/).last.first)
        overdue_count = overdue_text.scan(/\((\d+)\)$/).last.first

        attribs = {:id => uid,
                   :alias => user_alias,
                   :payments_btc => payments_btc,
                   :payments_count => payments_count,
                   :overdue_btc => overdue_btc,
                   :overdue_count => overdue_count}

        if user
          user.update_attributes!(attribs) or raise "Failed to update user #{uid}"
        else
          User.create!(attribs)
        end

        del_count = 0
      end

      uid += 1
    end
  end

  def profile_url
    "https://btcjam.com/users/#{self.id}"
  end

  def active_btc
    loans.where(:state => 'active').map(&:total_to_repay).reduce(:+) || 0
  end

  def active_count
    loans.where(:state => 'active').count
  end

  def repaid_btc
    loans.where(:state => 'repaid').map(&:total_to_repay).reduce(:+) || 0
  end

  def repaid_count
    loans.where(:state => 'repaid').count
  end

  def funding_btc
    loans.where(:state => 'funding').map(&:advertised_amount).reduce(:+) || 0
  end

  def funding_count
    loans.where(:state => 'funding').count
  end

  def overdue_loan_count
    loans.where(:state => 'overdue').count
  end

  def total_debt
    if loans.where(state: %w(active overdue)).count == 0
      0
    else
     (loans.where(state: %w(active repaid overdue)).map(&:total_to_repay).reduce(:+) || 0) - self.payments_btc
    end
  end

  def future_debt
    if loans.where(state: %w(active overdue)).count == 0
      loans.where(state: 'funding').map(&:total_to_repay).reduce(:+) || 0
    else
      (loans.where(state: %w(active repaid funding overdue)).map(&:total_to_repay).reduce(:+) || 0) - self.payments_btc
    end
  end

  private

  def self.from_btc_str(s)
    (s.to_f * 100000000.0).round
  end
end
