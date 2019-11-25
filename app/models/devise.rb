class Devise < ApplicationRecord
  validates :timestamp,       uniqueness: true
  validates :id,              uniqueness: true

  validates :timestamp,       presence: true
  validates :id,              presence: true
  validates :type,            presence: true
  validates :status,          presence: true
  validates :activity_change, presence: true

  validates :status, inclusion: { in: %w(online offline) }
  validates :type,   inclusion: { in: %w(gateway sensor) }
end
