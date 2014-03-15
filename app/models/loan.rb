class Loan < ActiveRecord::Base
  belongs_to :user

  def self.newest_loan
    agent = Mechanize.new
    agent.ca_file = Jammer::Application.config.ca_file

    page = agent.get("https://www.btcjam.com/listings/")
    highest_link = 0
    page.links_with(:href => /^\/listings\/\d+$/).each do |link|
      highest_link = [highest_link, link.href.sub(/.*\//, '').to_i].max
    end

    highest_link + 100 # to be on the safe side
  end

  def self.populate!
    agent = Mechanize.new
    agent.ca_file = Jammer::Application.config.ca_file

    (1..self.newest_loan).each do |loan_id|
      not_found = false

      begin
        page = agent.get("https://www.btcjam.com/listings/#{loan_id}")
      rescue Mechanize::ResponseCodeError => e
        if e.response_code == '404'
          not_found = true
        else
          raise
        end
      end

      loan = Loan.find_by_id(loan_id)

      if not_found
        unless loan.nil?
          loan.state = "deleted"
          loan.save
        end
      else
        user_id = page.links_with(:href => /^\/users\/\d+$/).first.href.sub(/.*\//, '').to_i
        name = page.title.sub(/ - BTCJam/, '')

        advertised_amount = from_btc_str(page.at('dt:contains("Amount @ Rate") ~ dd').text.scan(/^฿(\d+\.\d+)/).last.first)
        advertised_rate = page.at('dt:contains("Amount @ Rate") ~ dd').text.scan(/@ (\d+\.\d+)%$/).last.first

        btc_per_payment = from_btc_str(page.at('dt:contains("Payment") ~ dd').text.scan(/^฿(\d+\.\d+)$/).last.first)
        term = page.at('dt:contains("Term") ~ dd').text.scan(/^(\d+) days$/).last.first

        remaining_fund_amount = from_btc_str(page.at('div.funded').at('p.alignright').text.scan(/(\d+\.\d+)/).last.first)

        exchange_linked = (not page.image_with(alt: 'Glyphicons_050_link').nil?)

        case page.at('dt:contains("Payment") ~ dd ~ dd').at('small').text
        when 'Daily'
          frequency = 'daily'
        when 'Every 3 days'
          frequency = 'three_days'
        when 'Weekly'
          frequency = 'weekly'
        else
          frequency = 'monthly'
        end

        user_page = agent.get("https://www.btcjam.com/users/#{user_id}")
        state = user_page.at("//a[@href='/listings/#{loan_id}']").parent.parent.last_element_child.text.downcase.strip
        state = 'funding' if state == 'funding in progress'

        attribs = {:id => loan_id,
                   :user_id => user_id,
                   :name => name,
                   :advertised_amount => advertised_amount,
                   :advertised_rate => advertised_rate,
                   :btc_per_payment => btc_per_payment,
                   :term => term,
                   :remaining_fund_amount => remaining_fund_amount,
                   :state => state,
                   :exchange_linked => exchange_linked,
                   :frequency => frequency}

        if loan
          loan.update_attributes!(attribs) or raise "Failed to update loan #{loan_id}"
        else
          Loan.create!(attribs)
        end
      end
    end
  end

  def closing_amount
    advertised_amount - remaining_fund_amount
  end

  def total_to_repay
    btc_per_payment * payment_count
  end

  def payment_count
    case self.frequency
    when 'daily'
      self.term
    when 'three_days'
      (self.term.to_f / 3.0).ceil
    when 'weekly'
      (self.term.to_f / 7.0).ceil
    else
      (self.term.to_f / 30.0).ceil
    end
  end

  private

  def self.from_btc_str(s)
    (s.to_f * 100000000.0).round
  end
end