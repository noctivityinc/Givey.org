module GamesHelper
  def random_photos(friend)
    pics = friend.photos.sort_by{rand}[0..2]
  end

  def stuff_to_display(friend)
    friend.photos.count > 0 || friend.keys.select {|x| !dont_include(friend, x)}.count > 0
  end

  def dont_include(friend, key)
    %w{pic pic_square photos pic_big uid sex name significant_other_id first_name last_name email}.include?(key) || friend.send(key).blank?
  end

  def display_value(challenger, k)
    val = challenger.send(k)
    if val.is_a?(Hashie::Mash)
      if val.has_key?('name')
        val.name
      else
        val.first[1]
      end
    else
      val
    end
  end
  
end
