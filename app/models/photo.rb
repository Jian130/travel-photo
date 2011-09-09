# == Schema Information
# Schema version: 20110710085518
#
# Table name: photos
#
#  id                 :integer         not null, primary key
#  photo_file_name    :string(255)
#  photo_content_type :string(255)
#  photo_file_size    :integer
#  photo_updated_at   :datetime
#  photo_message      :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#
class Photo < ActiveRecord::Base
  
  attr_accessible :message, :image
  
  mount_uploader :image, ImageUploader
  
  belongs_to :post
  belongs_to :user
  
  before_create :update_exif, :update_image_attributes
  
  # validate_attachment_content_type
  # validate_attachment_presense  :image
  # validates_attachment_size :image, :less_than => 5.megabytes
  # validates_attachment_content_type :image, :content_type => ['image/jpeg', 'image/png', 'image/pjpg', 'image/x-png']
  def large_image
    self.image.large
  end
  
  def medium_image
    self.image.medium
  end
  
  private
  
  def update_image_attributes
    if image.present? && image_changed?
      self.size = image.file.size
    end
  end
  
  def update_exif
    image = EXIFR::JPEG.new(self.image.path)
  
    if image.exif? && !image.gps_latitude.nil?
      lat = image.gps_latitude[0].to_f + (image.gps_latitude[1].to_f / 60) + (image.gps_latitude[2].to_f / 3600)
      long = image.gps_longitude[0].to_f + (image.gps_longitude[1].to_f / 60) + (image.gps_longitude[2].to_f / 3600) 
      long = long * -1 if image.gps_longitude_ref == "W"   # (W is -, E is +)
      lat = lat * -1 if image.gps_latitude_ref == "S"      # (N is +, S is -)
    end
    
    if image.exif?
      self.latitude = lat unless lat.nil?
      self.longitude = long unless long.nil?
      self.taken_at = image.date_time_original
      # self.make = image.make
      # self.model - image.model
    end
  end
end
