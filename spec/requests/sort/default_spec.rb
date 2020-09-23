# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Post sorting', type: :request do
  before do
    Post.create(title: 'Foo Post')
    Post.create(title: 'Bar Post')
  end

  describe 'when no sort order is set in URL params' do
    before do
      get '/posts', headers: { accept: 'application/json' }
    end

    it 'returns the first item first' do
      expect(json_response[0][:title]).to eq('Bar Post')
    end

    it 'returns the last item last' do
      expect(json_response[-1][:title]).to eq('Foo Post')
    end
  end
end
