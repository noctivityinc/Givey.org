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
#

class Profile < ActiveRecord::Base
  MIN_REQUIRED = 3
  serialize :details
  serialize :photos
  
  has_many :selections, :class_name => "Spark", :foreign_key => "winner_uid", :primary_key => "uid" 
  has_many :questions, :class_name => "Question", :finder_sql => 'SELECT q.* FROM questions q INNER JOIN sparks s ON q.id = s.question_id WHERE (s.friend_uid_1 = \'#{uid}\' OR s.friend_uid_3 = \'#{uid}\' OR s.friend_uid_3 = \'#{uid}\')'
  has_many :questions_where_selected, :class_name => "Question", :finder_sql => 'SELECT q.* FROM questions q INNER JOIN sparks s ON q.id = s.question_id WHERE s.winner_uid = \'#{uid}\''
  has_many :questions_where_not_selected, :class_name => "Question", :finder_sql => 'SELECT q.* FROM questions q INNER JOIN sparks s ON q.id = s.question_id WHERE s.winner_uid <> \'#{uid}\' AND (s.friend_uid_1 = \'#{uid}\' OR s.friend_uid_2 = \'#{uid}\' OR s.friend_uid_3 = \'#{uid}\')'
  has_many :friend_lists, :class_name => 'User', :finder_sql => 'SELECT u.* FROM users u INNER JOIN friends f ON u.id = f.user_id WHERE f.uid = \'#{uid}\''

  scope :scorable, where("friend_list_count >= #{MIN_REQUIRED}")

  def scorable?
    friend_list_count >= MIN_REQUIRED
  end
  
  def update_friends_list_count!
    self.update_attribute(:friend_list_count, self.friend_lists.count)
  end
  
  def update_score!(value)
    if rand() >= 0.10 
      increment!(:score, value)
    else
      # to be EXTRA safe 10% of the time recalculate the score entirely based on source questions
      update_attribute(:score, questions_where_selected.sum(&:value))
    end
  end
end
