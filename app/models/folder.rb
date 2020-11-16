class Folder < ApplicationRecord

  acts_as_nested_set scope: :user,
                     counter_cache: :children_count

  belongs_to :user

end
