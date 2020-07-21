# 認証の流れは以下になります
#   https://i.udemycdn.com/redactor/raw/2018-06-16_11-30-31-5c1d94cb91beb75ceb3d805db4ce1ef5.png
class UserAuthenticator
  class AuthenticationError < StandardError; end

  attr_reader :authenticator

  def initialize(code: nil)
    @authenticator = if code.present?
                       Oauth.new(code)
                     else
                       Standard.new(login: nil, password: nil)
                     end
  end

  def perform
    # インスタンス変数にアクセスする際、 @ ありとなしがあったがなしでも大丈夫な
    # 場合は attr_reader を宣言しているものが対象になる
    authenticator.perform
  end

  def user
    authenticator.user
  end

  def access_token
    authenticator.access_token
  end
end
