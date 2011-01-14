module CampaignsHelper
  def get_all_friends
    uids = @campaign.friends_hash.map {|x| x.uid}
    return @all_friends.sort_by(&:name).map {|x| 
      {:uid =>  x.uid, :value => x.name, :in_list => uids.include?(x.uid.to_s), :name => x.name, :pic_square => x.pic_square}}.to_json
  end
end
