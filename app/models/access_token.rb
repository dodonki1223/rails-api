class AccessToken < ApplicationRecord
  belongs_to :user
  after_initialize :generate_token

  private

  def generate_token
    loop do
      # トークンがあって、自分以外のレコードで作成したアクセストークンが存在しない時
      break if token.present? && !AccessToken.where.not(id: id).exists?(token: token)
       self.token = SecureRandom.hex(10)
    end
  end
end
