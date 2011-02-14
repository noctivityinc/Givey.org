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
#

class Profile < ActiveRecord::Base
  MIN_REQUIRED = 3
  serialize :details
  serialize :photos
  
  has_many :selections, :class_name => "Spark", :foreign_key => "winner_uid", :primary_key => "uid" 
  has_many :selected_questions, :class_name => "Question", :finder_sql => 'SELECT q.* FROM questions q INNER JOIN sparks s ON q.id = s.question_id WHERE s.winner_uid = \'#{uid}\''
  has_many :friend_lists, :class_name => 'User', :finder_sql => 'SELECT u.* FROM users u INNER JOIN friends f ON u.id = f.user_id WHERE f.uid = \'#{uid}\''

  def score
    selected_questions.sum(&:value)
  end
  
  def scorable?
    friend_lists.count >= MIN_REQUIRED
  end
end
