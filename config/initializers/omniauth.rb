Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, 'iTzJLxVkCv3bafVF95HFg', '3LpB2NlzUeI7LNY0swwbUGKtbIqVAWtd5d4uZQzaw'
  provider :facebook , '176745529032044' , 'd9281c1aace16a61b9e90785042c9ac5' , {:scope => "publish_stream,email,offline_access"}
end