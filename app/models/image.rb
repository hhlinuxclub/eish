class Image < Asset
  belongs_to :attachable, :polymorphic => true
  belongs_to :user
  has_one :gallery
  
  validates_attachment_content_type :upload, :content_type => /image\/.*/
end