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
#  question_id        :integer
#

class Background < ActiveRecord::Base
  has_attached_file :photo, :styles => { :normal => "1024>", :thumb => "100" },
    :url => '/images/backgrounds/:basename_:style.:extension', 
    :path => ":rails_root/public/images/backgrounds/:basename_:style.:extension",
    :convert_options => { :all => '-strip -quality 20%'}

  before_create :randomize_file_name

  belongs_to :question
  
  validates_presence_of :photo
  validates_attachment_content_type :photo, :content_type => [ 'image/jpg', 'image/jpeg', 'image/gif', 'image/png' ]
  validates_attachment_size :photo, :less_than => 3.megabytes
  
  scope :active, where(:active => true)
  
  def randomize_file_name
    return if photo_file_name.nil?
    extension = File.extname(photo_file_name).downcase
    if photo_file_name_changed?
      self.photo.instance_write(:file_name, "#{ActiveSupport::SecureRandom.hex(16)}#{extension}")
    end
  end
  
  def self.pick
    active.sort_by{rand}.first
  end
  
end
