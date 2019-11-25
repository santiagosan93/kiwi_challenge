class Devise < ApplicationRecord
  validates :timestamp,       uniqueness: true
  validates :device_id,       uniqueness: true

  validates :timestamp,       presence: true
  validates :device_id,       presence: true
  validates :type,            presence: true
  validates :status,          presence: true

  validates :status, inclusion: { in: %w(online offline) }
  validates :type,   inclusion: { in: %w(gateway sensor) }
  # Devise.create(timestamp:"2017-05-01T00:00:10Z", device_id:"a4a281ad", device_type:"sensor", status:"offline")
end
