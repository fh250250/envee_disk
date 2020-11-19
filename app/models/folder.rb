class Folder < ApplicationRecord

  acts_as_nested_set scope: :user,
                     counter_cache: :children_count

  belongs_to :user

  validates :name,
            presence: true,
            length: { maximum: 32 },
            uniqueness: { scope: :parent_id }

end
