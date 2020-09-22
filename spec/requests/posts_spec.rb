# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Posts', type: :request do
  it 'returns list of Posts' do
    Post.create(title: 'Great Post', body: 'Body of the post')

    get '/posts', headers: { accept: 'application/json' }

    expect(json_response[0][:title]).to eq('Great Post')
  end
end
