class ShortenedUrl < ApplicationRecord
  validates :short_url, uniqueness: true, presence: true
  validates :long_url, uniqueness: true, presence: true

  belongs_to(:user,
    class_name: 'User',
    foreign_key: :user_id,
    primary_key: :id
  )

  has_many(:visits,
    class_name: 'Visit',
    foreign_key: :shortened_url_id,
    primary_key: :id
  )

  def num_clicks
    visits.length
  end

  def num_uniques
    result = []

    visits.each do |visit|
      result << visit.user_id
    end

    result.uniq.length
  end

  def num_recent_uniques
    arr = visits.select { |visit| (Time.now - visit.created_at) < 10.minutes }

    result = []
    arr.each do |visit|
      result << visit.user_id
    end

    result.uniq.length
  end
  # Factory method takes in useuserr and long urlsafe_base64
  # calls random code
  # passes user id, long URL passed to rand f(x), returns short urlsafe_base64
  # intialize with these arguments

  def self.random_code
    SecureRandom.urlsafe_base64
  end

  def self.shortened_urls(user_id, long_url)
    result = ShortenedUrl.random_code

    while ShortenedUrl.exists?(short_url: result)
      result = ShortenedUrl.random_code
    end
    # puts "short_url is now: #{result}"
    ShortenedUrl.new(user_id: user_id, long_url: long_url, short_url: result)
  end
end
