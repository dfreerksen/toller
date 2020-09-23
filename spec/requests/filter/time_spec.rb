# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Post filtering', type: :request do
  before do
    Post.create(title: 'Foo Post', expiration_time: '03:41:18')
    Post.create(title: 'Bar Post', expiration_time: '15:41:18')
    Post.create(title: 'Bat Post', expiration_time: '12:00:00')
    Post.create(title: 'Baz Post', expiration_time: '00:00:00')
  end

  describe 'when filtering by `expiration_time` time' do
    describe 'with specific expiration_time items (`?filter[expiration_time]=15:41:18`)' do
      before do
        get '/posts', params: { filters: { expiration_time: '15:41:18' } },
                      headers: { accept: 'application/json' }
      end

      it 'returns the first item' do
        expect(json_response[0][:title]).to eq('Bar Post')
      end

      it 'returns a specific count' do
        expect(json_response.size).to eq(1)
      end
    end

    describe 'with inclusive (..) range of items (`?filter[expiration_time]=00:00..12:00:00`)' do
      before do
        get '/posts', params: { filters: { expiration_time: '00:00..12:00:00' } },
                      headers: { accept: 'application/json' }
      end

      it 'returns the first item' do
        expect(json_response[0][:title]).to eq('Bat Post')
      end

      it 'returns the last item' do
        expect(json_response[-1][:title]).to eq('Foo Post')
      end

      it 'returns the last invisible item' do
        expect(json_response.size).to eq(3)
      end
    end

    describe 'with exclusive (..) range of items (`?filter[expiration_time]=00:00...12:00:00`)' do
      before do
        get '/posts', params: { filters: { expiration_time: '00:00...12:00:00' } },
                      headers: { accept: 'application/json' }
      end

      it 'returns the first item' do
        expect(json_response[0][:title]).to eq('Bat Post')
      end

      it 'returns the last item' do
        expect(json_response[-1][:title]).to eq('Foo Post')
      end

      it 'returns the last invisible item' do
        expect(json_response.size).to eq(3)
      end
    end
  end
end
