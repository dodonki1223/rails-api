require 'rails_helper'

shared_examples_for 'unauthorized_standard_requests' do
  let(:authentication_error) do
    {
      "status" => "401",
      "source" => { "pointer" => "/data/attributes/password" },
      "title" => "Invalid login or password",
      "detail" => "You must provide valid credentials in order to exchange them for token."
    }
  end

  it 'should return 401 status code' do
    subject
    expect(response).to have_http_status(401)
  end

  it 'should return proper error body' do
    subject
    expect(json['errors']).to include(authentication_error)
  end
end

shared_examples_for 'forbidden_requests' do
  let(:authorization_error) do
    {
      "status" => "401",
      "source" => { "pointer" => "/headers/authorization" },
      "title" => "Not authorized",
      "detail" => "You have no right to access this resource."
    }
  end

  # ページが存在するものの、特定のアクセス者にページを表示する権限が付与されず、アクセス
  # が拒否されたことをしめす
  it 'should return 403 statsu code' do
    subject
    expect(response).to have_http_status(:forbidden)
  end

  it 'should return proper error json' do
    subject
    expect(json['errors']).to include(authorization_error)
  end
end
