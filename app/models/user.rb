class User < ApplicationRecord

  after_create :create_root_folder

  has_secure_password

  has_many :folders

  validates :username,
            presence: true,
            length: { in: 3..32 },
            format: { with: /\A[A-Za-z0-9]+\z/ },
            uniqueness: true

  private

  def create_root_folder
    folders.create! name: "ROOT_#{id}"
  end

end
