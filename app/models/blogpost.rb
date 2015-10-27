class Blogpost < ActiveRecord::Base
  belongs_to :author, class_name: "User", foreign_key: "author_id"

  has_attached_file :featured_image, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/missing-image.png"
  validates_attachment_content_type :featured_image, content_type: /\Aimage\/.*\Z/

  validates :title, :short_description, :status, :featured_image, presence: true
  scope :published, -> { where(status: "published").order(published_at: :desc)}
end
