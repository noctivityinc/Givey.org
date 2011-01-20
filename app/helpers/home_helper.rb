module HomeHelper
  def unfinished_game
    current_user.games.incomplete.first
  end
end
