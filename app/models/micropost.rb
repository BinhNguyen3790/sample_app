class Micropost < ApplicationRecord
  belongs_to :user
  # scope :desc, ->order{created_at: :desc}
  default_scope ->{order created_at: :desc}
  scope :load_feed, ->(id){where user_id: id}
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true,
    length: {maximum: Settings.micropost.maximum}
  validate :picture_size

  private

  # Validates the size of an uploaded picture.
  def picture_size
    return if picture.size > Settings.micropost.picture_size .megabytes
    errors.add :picture, I18n.t("micropost.messages")
  end
end
