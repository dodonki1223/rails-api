# 認証の流れは以下になります
#   https://i.udemycdn.com/redactor/raw/2018-06-16_11-30-31-5c1d94cb91beb75ceb3d805db4ce1ef5.png
class UserAuthenticator
  class AuthenticationError < StandardError; end

  attr_reader :authenticator, :access_token

  # login: nil などの引数を使う場合は引数がセットされるかどうかわからない時に使用すること
  # 渡ってくる値が確実に決まっているのなら Standard.new(login, password) のように固定で宣言すること
  def initialize(code: nil, login: nil, password: nil)
    @authenticator = if code.present?
                       Oauth.new(code)
                     else
                       Standard.new(login, password)
                     end
  end

  def perform
    # インスタンス変数にアクセスする際、 @ ありとなしがあったがなしでも大丈夫な
    # 場合は attr_reader を宣言しているものが対象になる
    authenticator.perform

    set_access_token
  end

  def user
    authenticator.user
  end

  private

  def set_access_token
    @access_token = if user.access_token.present?
                      user.access_token
                    else
                      user.create_access_token
                    end
  end
end
