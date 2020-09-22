# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Post sorting', type: :request do
  before do
    Post.create(title: 'First Post')
    Post.create(title: 'Second Post')
  end

  describe 'when no sort order is set in URL params' do
    it 'returns the first item first' do
      get '/posts', headers: { accept: 'application/json' }

      expect(json_response[0][:title]).to eq('First Post')
    end

    it 'returns the last item last' do
      get '/posts', headers: { accept: 'application/json' }

      expect(json_response[-1][:title]).to eq('Second Post')
    end
  end
end
