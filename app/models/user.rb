require 'mechanize'

class User < ActiveRecord::Base
  has_many :loans
  has_many :investments

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
        begin
          user_alias = title.sub(/ - BTCJam$/, '')

          payments_text = page.at('dt:contains("Payments Made") ~ dd').text
          payments_btc = from_btc_str(payments_text.scan(/^฿(\d+\.\d+)/).last.first)
          payments_count = payments_text.scan(/\((\d+)\)$/).last.first

          overdue_text = page.at('dt:contains("Overdue Payments") ~ dd').text
          overdue_btc = from_btc_str(overdue_text.scan(/^฿(\d+\.\d+)/).last.first)
          overdue_count = overdue_text.scan(/\((\d+)\)$/).last.first

          credit_rating = {'A+' => 14, 'A' => 13, 'A-' => 12,
                           'B+' => 11, 'B' => 10, 'B-' => 9,
                           'C+' => 8, 'C' => 7, 'C-' => 6,
                           'D+' => 5, 'D' => 4, 'D-' => 3,
                           'E+' => 2, 'E' => 1, 'E-' => 0}[page.at('span.credit_label').text.gsub(/\s/, '')]

          attribs = {:id => uid,
                     :alias => user_alias,
                     :payments_btc => payments_btc,
                     :payments_count => payments_count,
                     :overdue_btc => overdue_btc,
                     :overdue_count => overdue_count,
                     :credit_rating => credit_rating}

          if user
            user.update_attributes!(attribs) or raise "Failed to update user #{uid}"
          else
            User.create!(attribs)
          end

          del_count = 0
        rescue
          del_count += 1
          puts "Failed to parse user #{uid}"
        end
      end

      uid += 1
    end
  end

  def User.update_cached_data!
    User.includes([:loans, :investments]).each do |user|
      user.active_btc = user.loans.select{ |loan| loan.state == 'active' }.map(&:total_to_repay).reduce(:+) || 0
      user.active_count = user.loans.select{ |loan| loan.state == 'active' }.count
      user.repaid_btc = user.loans.select{ |loan| loan.state == 'repaid' }.map(&:total_to_repay).reduce(:+) || 0
      user.repaid_count = user.loans.select{ |loan| loan.state == 'repaid' }.count
      user.funding_btc = user.loans.select{ |loan| loan.state == 'funding' }.map(&:advertised_amount).reduce(:+) || 0
      user.funding_count = user.loans.select{ |loan| loan.state == 'funding' }.count
      user.overdue_loan_count = user.loans.select{ |loan| loan.state == 'overdue' }.count
      if user.loans.select{ |loan| %w(active overdue).include? loan.state }.count == 0
        user.total_debt = 0
        user.future_debt = user.loans.select{ |loan| loan.state == 'funding' }.map(&:total_to_repay).reduce(:+) || 0
        user.total_debt_has_exchange_link = false
        user.future_debt_has_exchange_link = user.loans.select{ |loan| %w(funding).include?(loan.state) && loan.exchange_linked }.count > 0
      else
        user.total_debt = (user.loans.select{ |loan| %w(active repaid overdue).include? loan.state }.map(&:total_to_repay).reduce(:+) || 0) - user.payments_btc
        user.total_debt_has_exchange_link = user.loans.select{ |loan| %w(active overdue).include?(loan.state) && loan.exchange_linked }.count > 0
        user.future_debt = (user.loans.select{ |loan| %w(active repaid funding overdue).include? loan.state }.map(&:total_to_repay).reduce(:+) || 0) - user.payments_btc
        user.future_debt_has_exchange_link = user.loans.select{ |loan| %w(active funding overdue).include?(loan.state) && loan.exchange_linked }.count > 0
      end
      user.investments_btc = user.investments.map(&:amount).reduce(:+) || 0
      user.investments_count = user.investments.count
      user.active_investments_btc = user.investments.select{ |i| i.loan && i.loan.state == 'active' }.map(&:amount).reduce(:+) || 0
      user.active_investments_count = user.investments.select{ |i| i.loan && i.loan.state == 'active' }.count
      user.overdue_investments_btc = user.investments.select{ |i| i.loan && i.loan.state == 'overdue' }.map(&:amount).reduce(:+) || 0
      user.overdue_investments_count = user.investments.select{ |i| i.loan && i.loan.state == 'overdue' }.count
      user.funding_investments_btc = user.investments.select{ |i| i.loan && i.loan.state == 'funding' }.map(&:amount).reduce(:+) || 0
      user.funding_investments_count = user.investments.select{ |i| i.loan && i.loan.state == 'funding' }.count
      user.repaid_investments_btc = user.investments.select{ |i| i.loan && i.loan.state == 'funding' }.map(&:amount).reduce(:+) || 0
      user.repaid_investments_count = user.investments.select{ |i| i.loan && i.loan.state == 'funding' }.count

      # consensus appears to be that it's better to only include 'active' here
      total_active_borrowed = user.active_btc + user.funding_btc # + user.overdue_btc
      total_active_invested = user.active_investments_btc # + user.overdue_investments_btc
      if total_active_borrowed > 0 && total_active_invested > 0
        user.investment_ratio = total_active_invested.to_f / total_active_borrowed.to_f
      else
        user.investment_ratio = 0.0
      end
      user.loan_count = user.loans.count

      user.last_active_at = [user.last_active_at || Time.at(0).to_datetime,
                             user.loans.to_a.map{ |l| l.invested_at || Time.at(0).to_datetime }.max || Time.at(0).to_datetime,
                             user.investments.to_a.map{ |i| i.invested_at || Time.at(0).to_datetime }.max || Time.at(0).to_datetime].max

      user.save!
    end
  end

  def profile_url
    "https://btcjam.com/users/#{self.id}"
  end

  private

  def self.from_btc_str(s)
    (s.to_f * 100000000.0).round
  end
end
