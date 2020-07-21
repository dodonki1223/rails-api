# 認証の流れは以下になります
#   https://i.udemycdn.com/redactor/raw/2018-06-16_11-30-31-5c1d94cb91beb75ceb3d805db4ce1ef5.png
class UserAuthenticator::Oauth < UserAuthenticator
  class AuthenticationError < StandardError; end

  attr_reader :user, :access_token

  def initialize(code)
    @code = code
  end

  # perform は`行う`って意味
  def perform
    # コードがない、error を含んでいたら AuthenticationError とする
    raise AuthenticationError if code.blank?
    raise AuthenticationError if token.try(:error).present?

    prepare_user
    @access_token = if user.access_token.present?
                      user.access_token
                    else
                      user.create_access_token
                    end
  end

  private

  def client
    # Readme通りに client を作成: https://github.com/octokit/octokit.rb#making-requests
    @client ||= Octokit::Client.new(
      client_id: ENV['GITHUB_CLIENT_ID'],
      client_secret: ENV['GITHUB_CLIENT_SECRET']
    )
  end

  def token
    # ||= の書き方は左辺が存在しない場合、右辺の値が代入される仕組み、下記のように実行した場合は
    # hoge には 1 の値が入ることになる
    #   hoge ||= 1
    #   hoge ||= 2
    # exchange_code_for_token メソッドはアクセストークンを取得する
    #    コードからアクセストークンに変換しアクセストークンを取得する
    #    コードはGitHubにログイン(email と passwordを使用して)して取得したもの
    @token ||= client.exchange_code_for_token(code)
  end

  def user_data
    # アクセストークンを元にログインしたユーザーの情報を取得する
    #   Sawyer::Resource で返すが使い方もわからないので hash に変換して必要な項目だけを取得するようにslice しています
    @user_data ||= Octokit::Client.new(access_token: token)
                  .user
                  .to_h
                  .slice(:login, :avatar_url, :url, :name)
  end

  def prepare_user
    # ユーザーが既に存在していたらそのユーザーを取得し存在していなかったらユーザーを作成する
    @user = if User.exists?(login: user_data[:login])
              User.find_by(login: user_data[:login])
            else
              User.create(user_data.merge(provider: 'github'))
            end
  end

  attr_reader :code
end
