class Event < ApplicationRecord
  mount_uploader :image, ImageUploader
  belongs_to :user
  enum :status, { unsaved: 10, draft: 20, published: 30 }
  validates :title, :content, presence: true, if: :published?
  validate :verify_only_one_unsaved_status_is_allowed
  has_one_attached :avatar

  private

    def verify_only_one_unsaved_status_is_allowed
      if unsaved? && user.events.unsaved.present?
        raise StandardError, "未保存の記事は複数保有できません"
      end
    end
end
