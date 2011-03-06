
def get_send_invite_friend_reminder_emails_users
  User.not_scorable.where(["created_at >= '2011-03-07' AND completed_round_one_at <= ?",7.days.ago]).where(:emailed_invite_friends_at => nil).uniq
end

def send_invite_friend_reminder_emails
  users = get_send_invite_friend_reminder_emails_users
  puts "Emailing #{users.count} User Reminders."
  users.each do |user|
    puts "Emailing #{user.name} <#{user.email}>..."
    if UserMailer.invite_friend_reminder(user).deliver
      User.update(user.id, :emailed_invite_friends_at => Time.now)
    end
  end
end

def get_users_with_unlocked_scores
  User.scorable.where("created_at >= '2011-03-07'").where(:emailed_scores_unlocked_at => nil).uniq
end

def send_scores_unlocked_emails
  users = get_users_with_unlocked_scores
  puts "Emailing #{users.count} Scores Unlocked Users."
  users.each do |user|
    puts "Emailing #{user.name} <#{user.email}>..."
    if UserMailer.scores_unlocked(user).deliver
      User.update(user.id, :emailed_scores_unlocked_at => Time.now)
    end
  end
end

send_invite_friend_reminder_emails
send_scores_unlocked_emails