module AltruistsHelper
  def rank(ndx)
    return ndx+@altruists.offset+1
  end
end
