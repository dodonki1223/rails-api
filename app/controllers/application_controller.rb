class ApplicationController < ActionController::API
  rescue_from UserAuthenticator::AuthenticationError, with: :authentiation_error

  private

  def authentiation_error
    error = {
        "status" => "401",
        "source" => { "pointer" => "/code" },
        "title" => "Authentication code is invalid",
        "detail" => "You must provide valid code in order to exchange it for token."
    }
    render json: { "errors": [ error ] }, status: 401
  end
end
