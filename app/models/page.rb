class Page < ApplicationRecord
    has_many :assets
    validates :url, presence: true, uniqueness: true
end
  
