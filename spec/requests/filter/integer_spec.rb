# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Post filtering', type: :request do
  before do
    Post.create(title: 'Foo Post', priority: 0)
    Post.create(title: 'Bar Post', priority: 1)
    Post.create(title: 'Bat Post', priority: 1)
    Post.create(title: 'Baz Post', priority: 2)
    Post.create(title: 'Qux Post', priority: 3)
  end

  describe 'when filtering by `priority` integer' do
    describe 'with priority items (`?filter[priority]=1`)' do
      it 'returns the first priority item' do
        get '/posts', params: { filters: { priority: 1 } },
                      headers: { accept: 'application/json' }

        expect(json_response[0][:title]).to eq('Bar Post')
      end

      it 'returns the last priority item' do
        get '/posts', params: { filters: { priority: 1 } },
                      headers: { accept: 'application/json' }

        expect(json_response[-1][:title]).to eq('Bat Post')
      end
    end

    describe 'with priority items in range (`?filter[priority]=1..3`)' do
      it 'returns the first priority item' do
        get '/posts', params: { filters: { priority: '1..3' } },
                      headers: { accept: 'application/json' }

        expect(json_response[0][:title]).to eq('Bar Post')
      end

      it 'returns the last priority item' do
        get '/posts', params: { filters: { priority: '1..3' } },
                      headers: { accept: 'application/json' }

        expect(json_response[-1][:title]).to eq('Qux Post')
      end

      it 'returns the correct number of priority range items' do
        get '/posts', params: { filters: { priority: '1..3' } },
                      headers: { accept: 'application/json' }

        expect(json_response.size).to eq(4)
      end
    end

    describe 'with priority items in array (`?filter[priority]=[1,3]`)' do
      it 'returns the first priority item' do
        get '/posts', params: { filters: { priority: [1, 3] } },
                      headers: { accept: 'application/json' }

        expect(json_response[0][:title]).to eq('Bar Post')
      end

      it 'returns the last priority item' do
        get '/posts', params: { filters: { priority: [1, 3] } },
                      headers: { accept: 'application/json' }

        expect(json_response[-1][:title]).to eq('Qux Post')
      end

      it 'returns the correct number of priority array of items' do
        get '/posts', params: { filters: { priority: [1, 3] } },
                      headers: { accept: 'application/json' }

        expect(json_response.size).to eq(3)
      end
    end
  end
end
