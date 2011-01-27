# == Schema Information
#
# Table name: npos
#
#  id                :integer         not null, primary key
#  name              :string(255)
#  website           :string(255)
#  email             :string(255)
#  description       :text
#  category_id       :integer
#  feature           :boolean
#  num_featured      :integer
#  active            :boolean
#  summary           :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#  address_1         :string(255)
#  address_2         :string(255)
#  city              :string(255)
#  state             :string(255)
#  zip_code          :string(255)
#  attention         :string(255)
#  twitter_name      :string(255)
#  facebook_url      :string(255)
#  guidestar_url     :string(255)
#  logo_file_name    :string(255)
#  logo_content_type :string(255)
#  logo_file_size    :integer
#  logo_updated_at   :datetime
#  paypal_email      :string(255)
#  tax_id            :string(255)
#  story             :text
#

require 'test_helper'

class NpoTest < ActiveSupport::TestCase
  should "be valid" do
    assert Npo.new.valid?
  end
end
