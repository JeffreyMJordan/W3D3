class User < ApplicationRecord
  validates :email, uniqueness: true, presence: true

  has_many(:urls_shortened,
    class_name: 'ShortenedUrl',
    foreign_key: :user_id,
    primary_key: :id
  )
end
