# == Schema Information
#
# Table name: backgrounds
#
#  id                 :integer         not null, primary key
#  active             :boolean         default(TRUE)
#  created_at         :datetime
#  updated_at         :datetime
#  photo_file_name    :string(255)
#  photo_content_type :string(255)
#  photo_file_size    :integer
#  photo_updated_at   :datetime
#

require 'test_helper'

class BackgroundTest < ActiveSupport::TestCase
  should "be valid" do
    assert Background.new.valid?
  end
end
