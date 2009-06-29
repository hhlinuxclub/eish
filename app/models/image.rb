class Image < Asset
  belongs_to :attachable, :polymorphic => true
  belongs_to :user
  has_one :gallery
  
  validates_attachment_content_type :upload, :content_type => ["image/gif", "image/jpeg", "image/png", "image/pjpeg", "image/x-png"]
  validates_attachment_presence :upload
end