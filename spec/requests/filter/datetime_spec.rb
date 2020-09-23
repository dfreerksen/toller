# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Post filtering', type: :request do
  before do
    Post.create(title: 'Foo Post', published_at: '1775-11-10 03:41:18')
    Post.create(title: 'Bar Post', published_at: '1776-07-04 15:41:18')
    Post.create(title: 'Bat Post', published_at: '1845-12-29 12:00:00')
    Post.create(title: 'Baz Post', published_at: '2020-05-25 00:00:00')
  end

  describe 'when filtering by `published_at` time' do
    describe 'with specific published_at items (`?filter[published_at]=1776/07/04 15:41:18`)' do
      before do
        get '/posts', params: { filters: { published_at: '1776/07/04 15:41:18' } },
                      headers: { accept: 'application/json' }
      end

      it 'returns the first item' do
        expect(json_response[0][:title]).to eq('Bar Post')
      end

      it 'returns a specific count' do
        expect(json_response.size).to eq(1)
      end
    end

    describe 'with inclusive (..) range of items (`?filter[published_at]=1775/11/10 00:00..1845/12/29 12:00:00`)' do
      before do
        get '/posts', params: { filters: { published_at: '1775/11/10 00:00..1845/12/29 12:00:00' } },
                      headers: { accept: 'application/json' }
      end

      it 'returns the first item' do
        expect(json_response[0][:title]).to eq('Bar Post')
      end

      it 'returns the last item' do
        expect(json_response[-1][:title]).to eq('Foo Post')
      end

      it 'returns the last invisible item' do
        expect(json_response.size).to eq(3)
      end
    end

    describe 'with exclusive (..) range of items (`?filter[published_at]=1775/11/10 00:00...1845/12/29 12:00:00`)' do
      before do
        get '/posts', params: { filters: { published_at: '1775/11/10 00:00...1845/12/29 12:00:00' } },
                      headers: { accept: 'application/json' }
      end

      it 'returns the first item' do
        expect(json_response[0][:title]).to eq('Bar Post')
      end

      it 'returns the last item' do
        expect(json_response[-1][:title]).to eq('Foo Post')
      end

      it 'returns the last invisible item' do
        expect(json_response.size).to eq(3)
      end
    end

    describe 'with range of items without time(`?filter[published_at]=1775/11/10...1845/12/29`)' do
      before do
        get '/posts', params: { filters: { published_at: '1775/11/10...1845/12/29' } },
                      headers: { accept: 'application/json' }
      end

      it 'returns the first item' do
        expect(json_response[0][:title]).to eq('Bar Post')
      end

      it 'returns the last item' do
        expect(json_response[-1][:title]).to eq('Foo Post')
      end

      it 'returns the last invisible item' do
        expect(json_response.size).to eq(2)
      end
    end
  end
end
