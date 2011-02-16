module FriendsHelper
  def get_background_class(a)
    return a.profile.score < 0 ? 'neg' : 'pos'
  end
end
