# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Post filtering', type: :request do
  before do
    Post.create(title: 'Foo Post')
    Post.create(title: 'Bar Post')
  end

  describe 'when filtering by `title` string' do
    describe 'with items (`?filter[title]=Foo Post`)' do
      before do
        get '/posts', params: { filters: { title: 'Foo Post' } },
                      headers: { accept: 'application/json' }
      end

      it 'returns the first visible item' do
        expect(json_response[0][:title]).to eq('Foo Post')
      end

      it 'returns specific item count' do
        expect(json_response.size).to eq(1)
      end
    end
  end

  describe 'when filtering by alias `post_title`' do
    describe 'with items (`?filter[post_title]=Bar Post`)' do
      before do
        get '/posts', params: { filters: { post_title: 'Bar Post' } },
                      headers: { accept: 'application/json' }
      end

      it 'returns the first visible item' do
        expect(json_response[0][:title]).to eq('Bar Post')
      end

      it 'returns specific item count' do
        expect(json_response.size).to eq(1)
      end
    end
  end
end
