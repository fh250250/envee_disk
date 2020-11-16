class LoginForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :username, :string
  attribute :password, :string
  attribute :remember_me, :boolean

  validates :username, :password, presence: true

  def submit
    return false unless valid?

    User.find_by(username: username).try(:authenticate, password)
  end

end
