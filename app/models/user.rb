require 'mechanize'

class User < ActiveRecord::Base
  def self.populate!
    agent = Mechanize.new
    agent.ca_file = Jammer::Application.config.ca_file

    uid = 1
    del_count = 0

    loop do
      page = agent.get("https://www.btcjam.com/users/#{uid}")

      user = User.where(uid => :id)

      title = page.title
      if title == 'Peer to Peer Bitcoin Lending - BTCJam'
        # redirects to front page if we find a deleted user
        del_count += 1

        # assuming a row of 10 deleted users means we've run out of users. It's an unusual-enough occurrence
        break if del_count > 10
      else
        # We've found a user
        attribs = {:id => uid, :alias => title.sub(/ - BTCJam$/, '')}
        if user
          user.update_attributes!(attribs)
        else
          User.create!(attribs)
        end

        del_count = 0
      end

      uid += 1
    end
  end
end
