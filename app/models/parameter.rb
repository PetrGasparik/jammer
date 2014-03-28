class Parameter < ActiveRecord::Base
  validates :key, :presence => true, :uniqueness => true

  def self.set_last_update_time!
    p = Parameter.find_by_key('last_update') || Parameter.new(:key => 'last_update')
    p.value = DateTime.now.utc.strftime('%Y-%m-%d %H:%M:%S UTC')
    p.save!
  end

  def self.set_update_running!
    p = Parameter.find_by_key('last_update') || Parameter.new(:key => 'last_update')
    p.value = 'In Progress'
    p.save!
  end

  def self.set_update_failed!
    p = Parameter.find_by_key('last_update') || Parameter.new(:key => 'last_update')
    p.value = DateTime.now.utc.strftime('FAILED at %Y-%m-%d %H:%M:%S UTC')
    p.save!
  end
end
