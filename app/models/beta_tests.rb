class BetaTests < ActiveRecord::Base
    attr_accessible :email, :access_count, :last_accessed_at, :feedback
end
