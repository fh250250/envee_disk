class User < ApplicationRecord

  has_secure_password

  has_many :folders

  validates :username,
            presence: true,
            length: { in: 3..32 },
            format: { with: /\A[A-Za-z0-9]+\z/ },
            uniqueness: true

end
