class AccessTokensController < ApplicationController
  skip_before_action :authorize!, only: :create

  # POST /login 
  def create
    # もしここでエラーが起きた場合は ApplicationController で宣言している下記のコードが実行されエラーが返される
    #   rescue_from UserAuthenticator::AuthenticationError, with: :authentiation_error
    authenticator = UserAuthenticator.new(params[:code])
    authenticator.perform

    # ユーザーのアクセストークンを json で返す
    render json: AccessTokenSerializer.new(authenticator.access_token), status: :created 
  end

  # DELETE /logout
  def destroy
    current_user.access_token.destroy
  end
end
