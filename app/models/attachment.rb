# encoding: utf-8

class Attachment < ActiveRecord::Base
  has_attached_file :file

  validates :motion_id, :presence => true

  validates_attachment :file, :presence => true,
    :size => { :in => 0..MAX_ATTACHMENT_SIZE }

  belongs_to :motion

  def file_name
    file_file_name
  end

  def file_size
    file_file_size
  end

  def file_extension
    file_name.gsub(/.*\./, "")
  end

  def icon_path
    a = Antrag::Application.assets.find_asset "fileicons/#{file_extension}.png"

    "/assets/fileicons/#{a ? file_extension : "_blank"}.png"
  end
end
