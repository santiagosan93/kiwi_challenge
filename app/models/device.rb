require "csv"
class Device < ApplicationRecord
  validates :timestamp,       uniqueness: true
  validates :device_id,       uniqueness: true

  validates :timestamp,       presence: true
  validates :device_id,       presence: true
  validates :device_type,     presence: true
  validates :status,          presence: true

  validates :device_type,     inclusion: { in: %w[gateway sensor] }
  validates :status,          inclusion: { in: %w[online offline] }
end
