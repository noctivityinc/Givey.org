module SparksHelper
  
  def question_count
    "#{current_user.sparks.decided.count+1} of 25" if current_user.sparks.decided.count < 25
  end

  def random_photos(profile)
    pics = profile.photos.sort_by{rand}[0..2]
  end

  def stuff_to_display(profile)
    profile.photos.count > 0 || profile.details.keys.detect {|x| !dont_include(profile, x)}
  end

  def dont_include(profile, key)
    %w{pic pic_square photos pic_big uid sex name significant_other_id first_name last_name email}.include?(key) || profile.details.send(key).blank?
  end

  def display_value(profile, k)
    val = profile.details.send(k)
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

  def not_selected_names(s)
    return s.not_selected.map {|x| "<span class='not_selected_name'>#{x.details.name}</span>"}.join(' and ')
  end

  def donation_overlay
    if session[:donation_complete]
      session[:donation_complete] = nil # => resetting so we dont show twice
      return true
    end
  end
  
  def get_npo_options
    npos = Npo.active.featured.map {|x| [x.name, x.id]}
    npos << ['Other','other']
    npos
  end
  
  def mturk_confirmation_code
    @mturk = Mturk.find_by_uid(current_user.uid)
    @mturk.confirmation_token if @mturk
  end
end
