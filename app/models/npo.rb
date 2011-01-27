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

class Npo < ActiveRecord::Base
  has_attached_file :logo, :styles => { :medium => "200X200>", :thumb => "100x100>" },
    :url => '/images/npos/:id/:basename_:style.:extension', 
    :path => ":rails_root/public/images/npos/:id/:basename_:style.:extension"
    
  before_create :randomize_file_name

  has_many :slots
  has_many :campaigns, :through => :slots
  belongs_to :category
  
  validates_presence_of :name, :website, :description, :summary, :category

  def self.pick
    all.sort_by{rand}.first
  end
  
  private
  
  def randomize_file_name
    return if photo_file_name.nil?
    extension = File.extname(photo_file_name).downcase
    if photo_file_name_changed?
      self.photo.instance_write(:file_name, "#{ActiveSupport::SecureRandom.hex(16)}#{extension}")
    end
  end
end
