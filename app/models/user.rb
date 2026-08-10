class User < ApplicationRecord
  USERNAME_FORMAT = /\A[a-zA-Z0-9_-]+\z/

  has_secure_password

  has_many :sessions, dependent: :destroy
  has_many :chat_members
  has_many :chats, through: :chat_members
  has_many :messages, foreign_key: :author_id

  has_one_attached :profile_picture

  validates :username, presence: true, uniqueness: true
  validate :profile_picture_size
  validate :profile_picture_type
  validates :username,
    format: {
      with: USERNAME_FORMAT,
      message: "may only contain letters, numbers, hyphens, and underscores"
    }

  def to_param
    username
  end

  private

  def profile_picture_size
    return unless profile_picture.attached?

    if profile_picture.blob.byte_size > 2.megabytes
      errors.add(:profile_picture, "is too large (maximum is 2 MB)")
    end
  end

  def profile_picture_type
    return unless profile_picture.attached?

    unless profile_picture.content_type.in?(%w[image/jpeg image/png image/webp image/gif])
      errors.add(:profile_picture, "must be JPEG, PNG, GIF or WebP")
    end
  end
end
