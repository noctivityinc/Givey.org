# == Schema Information
#
# Table name: profiles
#
#  id                :integer         not null, primary key
#  uid               :string(255)
#  details           :text
#  photos            :text
#  created_at        :datetime
#  updated_at        :datetime
#  friend_list_count :integer
#  score             :integer
#  givey_token       :string(255)
#

class Profile < ActiveRecord::Base
  MIN_FRIEND_LISTS_REQUIRED = 3
  serialize :details
  serialize :photos

  before_create :generate_givey_token

  has_many :selections, :class_name => "Spark", :foreign_key => "winner_uid", :primary_key => "uid"
  has_many :questions, :class_name => "Question", :finder_sql => 'SELECT q.* FROM questions q INNER JOIN sparks s ON q.id = s.question_id WHERE (s.friend_uid_1 = \'#{uid}\' OR s.friend_uid_3 = \'#{uid}\' OR s.friend_uid_3 = \'#{uid}\')'
  has_many :questions_where_selected, :class_name => "Question", :finder_sql => 'SELECT q.* FROM questions q INNER JOIN sparks s ON q.id = s.question_id WHERE s.winner_uid = \'#{uid}\''
  has_many :questions_where_not_selected, :class_name => "Question", :finder_sql => 'SELECT q.* FROM questions q INNER JOIN sparks s ON q.id = s.question_id WHERE s.winner_uid <> \'#{uid}\' AND (s.friend_uid_1 = \'#{uid}\' OR s.friend_uid_2 = \'#{uid}\' OR s.friend_uid_3 = \'#{uid}\')'
  has_many :friend_lists, :class_name => 'User', :finder_sql => 'SELECT u.* FROM users u INNER JOIN friends f ON u.id = f.user_id WHERE f.uid = \'#{uid}\''
  belongs_to :user, :class_name => "User", :foreign_key => "uid", :primary_key => "uid"

  scope :scorable, where("friend_list_count >= #{MIN_FRIEND_LISTS_REQUIRED}")
  scope :by_score, order("score DESC")

  validates_uniqueness_of :uid

  def self.create_or_update(attributes)
    profile = Profile.find_by_uid(attributes[:uid])
    if profile
      profile.update_attributes(attributes)
    else
      Profile.create(attributes)
    end
  end

  def scorable?
    friend_list_count >= MIN_FRIEND_LISTS_REQUIRED if friend_list_count
  end

  def is_user?
    !self.user.nil?
  end

  def update_friends_list_count!
    self.update_attribute(:friend_list_count, self.friend_lists.count)
  end

  def update_score!(value)
    if rand() >= 0.10
      increment!(:score, value)
    else
      # to be EXTRA safe 10% of the time recalculate the score entirely based on source questions
      update_attribute(:score, questions_where_selected.inject(0) {|res,x| res += x.value})
    end
  end

  private

    def generate_givey_token
      self.givey_token = rand(36**8).to_s(36)
    end

end
