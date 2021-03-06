class ApplicationController < ActionController::API
  class AuthorizationError < StandardError; end
  rescue_from UserAuthenticator::Oauth::AuthenticationError, with: :authentiation_oauth_error
  rescue_from UserAuthenticator::Standard::AuthenticationError, with: :authentiation_standard_error
  rescue_from AuthorizationError, with: :authorization_error

  # 認証プロセスの考え方は２つある
  #   - 必要な部分だけ認証させる
  #   - 認証プロセスを常にさせる、必要のない箇所だけ認証プロセスをスキップさせる
  # `認証プロセスを常にさせる、必要のない箇所だけ認証プロセスをスキップさせる` こっちの方が、
  # セキュリティ的には高くなる！！
  before_action :authorize!

  private

  def authorize!
    raise AuthorizationError unless current_user
  end

  def access_token
    # `Bearer 9fad45e488218e1c5ae0` この形式のものから `9fad45e488218e1c5ae0` だけを抽出する
    # `Bearer 9fad45e488218e1c5ae0` が指定されていない時は request.authorization が nil を返すため
    # .gsub でエラーが発生してしまう
    #
    # obj&.to_i レシーバが nil の場合に nil を返す
    #   10&.to_s  # => "10"
    #   nil&.to_s # nil
    #
    # try と &. の違い
    #   両方とも『レシーバが nil ではない場合にメソッドを呼び出す』という目的なんですが、具体的な挙動は少し違っています。 
    #   &.が『nilでない場合にメソッドを呼び出す』のに対して、#try は『メソッドを呼び出すことができるときにメソッドを呼び出す』と
    #   いうような挙動になります。 どういうことかというと
    #     # 10 には #hoge メソッドは定義されていない（呼び出せない）ので nil を返す
    #     10.try(:hoge)   # => nil
    #     # レシーバは nil ではないので #hoge メソッドを呼びだそうとするが
    #     # #hoge メソッドは定義されてないのでエラー
    #      10&.hoge # => Error: undefined method `hoge' for 10:Fixnum (NoMethodError)
    #   というような挙動になります。
    #   これは #try が respond_to? を使用して『メソッドを呼びだせるかどうか』をチェックしているためです。
    #   このような違いがあるため &. を #try の代替として使用する場合は注意して使用する必要があります。
    #   https://secret-garden.hatenablog.com/entry/2016/09/02/000000
    provided_token = request.authorization&.gsub(/\ABearer\s/, '')

    # アクセストークンを取得しそのユーザーを取得
    @access_token = AccessToken.find_by(token: provided_token)
  end

  def current_user
    @current_user = access_token&.user
  end

  def authentiation_oauth_error
    error = {
        "status" => "401",
        "source" => { "pointer" => "/code" },
        "title" => "Authentication code is invalid",
        "detail" => "You must provide valid code in order to exchange it for token."
    }
    render json: { "errors": [ error ] }, status: 401
  end

  def authentiation_standard_error
    error = {
      "status" => "401",
      "source" => { "pointer" => "/data/attributes/password" },
      "title" => "Invalid login or password",
      "detail" => "You must provide valid credentials in order to exchange them for token."
    }
    render json: { "errors": [ error ] }, status: 401
  end

  def authorization_error
    error = {
        "status" => "401",
        "source" => { "pointer" => "/headers/authorization" },
        "title" => "Not authorized",
        "detail" => "You have no right to access this resource."
    }
    render json: { "errors": [ error ] }, status: 403
  end
end
