require 'mechanize'

class User < ActiveRecord::Base
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
        
        active_text = page.at('dt:contains("Active Loans") ~ dd').text
        active_btc = active_text.scan(/^฿(\d+\.\d+)/).last.first
        active_count = active_text.scan(/\((\d+)\)$/).last.first

        repaid_text = page.at('dt:contains("Repaid Loans") ~ dd').text
        repaid_btc = repaid_text.scan(/^฿(\d+\.\d+)/).last.first
        repaid_count = repaid_text.scan(/\((\d+)\)$/).last.first

        payments_text = page.at('dt:contains("Payments Made") ~ dd').text
        payments_btc = payments_text.scan(/^฿(\d+\.\d+)/).last.first
        payments_count = payments_text.scan(/\((\d+)\)$/).last.first

        overdue_text = page.at('dt:contains("Overdue Payments") ~ dd').text
        overdue_btc = overdue_text.scan(/^฿(\d+\.\d+)/).last.first
        overdue_count = overdue_text.scan(/\((\d+)\)$/).last.first

        attribs = {:id => uid,
                   :alias => user_alias,
                   :active_btc => active_btc,
                   :active_count => active_count,
                   :repaid_btc => repaid_btc,
                   :repaid_count => repaid_count,
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
end
