class Post < ApplicationRecord
  has_one_attached :cover_image
  belongs_to :user

  validates :title, presence: true, length: { minimum: 5 }
  validates :content, presence: true, length: { minimum: 10 }

  after_commit :process_cover_image_async, on: [:create, :update]

  private

  def process_cover_image_async
    ProcessCoverImageJob.set(wait: 30.seconds).perform_later(self)
  end
end
