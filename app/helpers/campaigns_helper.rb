module CampaignsHelper
  def continue_match_link
    match = current_user.matches.incomplete.first
    campaign_match_path(match.campaign, match)
  end
end
