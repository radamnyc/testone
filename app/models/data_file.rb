class DataFile < ApplicationRecord
  # 🚅 add concerns above.

  attr_accessor :file_removal
  # 🚅 add attribute accessors above.

  belongs_to :team
  # 🚅 add belongs_to associations above.

  has_many :project_data_files, dependent: :destroy
  has_many :projects, through: :project_data_files
  # 🚅 add has_many associations above.

  has_one_attached :file
  # 🚅 add has_one associations above.

  # 🚅 add scopes above.

  validates :description, presence: true
  # 🚅 add validations above.

  after_validation :remove_file, if: :file_removal?
  # 🚅 add callbacks above.

  # 🚅 add delegations above.

  def file_removal?
    file_removal.present?
  end

  def remove_file
    file.purge
  end
  # 🚅 add methods above.
end
