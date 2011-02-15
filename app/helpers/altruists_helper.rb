module AltruistsHelper
  def rank(ndx)
    return ndx+@altruists.offset+1
  end

  def altruist_isnt_current_user
    current_user.profile != @altruist
  end
  
  def display_classfied_gender
    if @altruist.details.sex.blank?
      return 'be classified.'
    elsif @altruist.details.sex == 'male'
      return 'classify him.'
    else
      return 'classify him.'
    end
  end
end
