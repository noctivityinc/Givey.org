module CandidatesHelper
  def candidate_link
    return "http://#{APP_CONFIG[:domain]}/#{@candidate.givey_token}"
  end
end
