class User < ApplicationRecord
  include BCrypt

  validates :login, presence: true, uniqueness: true
  validates :provider, presence: true
  validates :password, presence: true, if: -> { provider == 'standard' }

  has_one :access_token, dependent: :destroy
  has_many :articles, dependent: :destroy
  has_many :comments, dependent: :destroy

  def password
    # OAuth をサポートしているためパスワードが入っていない場合があるため、
    # 空の時は何もしない処理が必要である
    # BCrypt を使用しているので hash が入っていないとエラーになるため、
    # 「if encrypted_password.present?」この処理が必要である
    @password ||= Password.new(encrypted_password) if encrypted_password.present?
  end

  def password=(new_password)
    return @password = new_password if new_password.blank?
    @password = Password.create(new_password)
    self.encrypted_password = @password
  end
end
