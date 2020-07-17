require 'rails_helper'

describe 'articles routes' do
  it 'should route to articles index' do
    expect(get '/articles').to route_to('articles#index')
  end

  it 'should route to articles show' do
    # id の指定は文字列でないといけない
    expect(get '/articles/1').to route_to('articles#show', id: '1')
  end

  it 'shourd route to articles create' do
    expect(post '/articles').to route_to('articles#create')
  end

  it 'shourd route to articles update' do
    expect(put '/articles/1').to route_to('articles#update', id: '1')
    expect(patch '/articles/1').to route_to('articles#update', id: '1')
  end
end
