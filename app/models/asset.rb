class Asset < ApplicationRecord
  belongs_to :page
  validates :url, presence: true
end
  