# == Schema Information
#
# Table name: npos
#
#  id           :integer         not null, primary key
#  name         :string(255)
#  website      :string(255)
#  email        :string(255)
#  description  :text
#  category_id  :integer
#  feature      :boolean
#  num_featured :integer
#  active       :boolean
#  summary      :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#

require 'test_helper'

class NpoTest < ActiveSupport::TestCase
  should "be valid" do
    assert Npo.new.valid?
  end
end
