class Folder < ApplicationRecord

  acts_as_nested_set scope: :user,
                     counter_cache: :children_count,
                     dependent: :restrict_with_error

  belongs_to :user
  has_many :uploads
  has_many :meta_files

  validates :name,
            presence: true,
            length: { maximum: 32 },
            uniqueness: { scope: :parent_id }

  def compat_name
    root? ? "根目录" : name
  end

  def can_destroy?
    leaf? and uploads.count == 0 and meta_files.count == 0
  end

end
