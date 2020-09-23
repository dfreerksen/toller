# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Article filtering', type: :request do
  before do
    Post.create(title: 'Foo Post')
    Post.create(title: 'Bar Post')
  end

  describe 'using custom param key (`filtrations`) when filtering by `title` string' do
    describe 'with items (`?filtrations[title]=Foo Post`)' do
      before do
        get '/articles', params: { filtrations: { title: 'Foo Post' } },
                         headers: { accept: 'application/json' }
      end

      it 'returns the first item' do
        expect(json_response[0][:title]).to eq('Foo Post')
      end

      it 'returns specific item count' do
        expect(json_response.size).to eq(1)
      end
    end
  end
end
