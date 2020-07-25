class AccessTokensController < ApplicationController
  skip_before_action :authorize!, only: :create

  # POST /login 
  def create
    # もしここでエラーが起きた場合は ApplicationController で宣言している下記のコードが実行されエラーが返される
    #   rescue_from UserAuthenticator::AuthenticationError, with: :authentiation_error
    # params[:code] だと 他の認証のフローを簡単に追加できないためよくない（拡張性がない）
    authenticator = UserAuthenticator.new(authentication_params)
    authenticator.perform

    # ユーザーのアクセストークンを json で返す
    render json: AccessTokenSerializer.new(authenticator.access_token), status: :created 
  end

  # DELETE /logout
  def destroy
    current_user.access_token.destroy
  end

  private

  def authentication_params
    # ハッシュに変換してシンボル化する
    (standard_auth_params || params.permit(:code)).to_h.symbolize_keys
  end

  def standard_auth_params
    # Rails コンソールで確認する時は以下のようにする
    #   irb(main):001:0> params = ActionController::Parameters.new(code: 'sample')
    #   => <ActionController::Parameters {"code"=>"sample"} permitted: false>
    #   irb(main):002:0> params.permit(:code)
    #   => <ActionController::Parameters {"code"=>"sample"} permitted: true>
    #  
    #   irb(main):003:0> params = ActionController::Parameters.new(data: { attributes: { login: 'login', password: 'password' } })
    #   => <ActionController::Parameters {"data"=>{"attributes"=>{"login"=>"login", "password"=>"password"}}} permitted: false>
    #   irb(main):004:0> params.permit(data: { attributes: {} })
    #   => <ActionController::Parameters {"data"=><ActionController::Parameters {"attributes"=><ActionController::Parameters {"login"=>"login", "password"=>"password"} permitted: true>} permitted: true>} permitted: true>
    # digメソッドを使用して余分な階層を排除して形で受け取る。さらに取り回ししやすいように to_h する
    #   irb(main):007:0> params.dig(:data, :attributes).permit(:login, :password).to_h
    #   => {"login"=>"login", "password"=>"password"}

    # &. を使う理由は dig(:data, :attributes) キーが存在しない時、プログラムでエラーを返すため、
    # &. を使用しては nil を返すようにする
    params.dig(:data, :attributes)&.permit(:login, :password)
  end
end
