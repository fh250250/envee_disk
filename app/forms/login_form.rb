class LoginForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :username, :string
  attribute :password, :string
  attribute :remember_me, :boolean

  validates :username, :password, presence: true

end
