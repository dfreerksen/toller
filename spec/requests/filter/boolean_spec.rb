# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Post filtering', type: :request do
  before do
    Post.create(title: 'Foo Post', visible: 0)
    Post.create(title: 'Bar Post', visible: 1)
    Post.create(title: 'Bat Post', visible: 0)
    Post.create(title: 'Baz Post', visible: 1)
  end

  describe 'when filtering by `visible` boolean' do
    describe 'with visible items (`?filter[visible]=1`)' do
      before do
        get '/posts', params: { filters: { visible: 1 } },
                      headers: { accept: 'application/json' }
      end

      it 'returns the first visible item' do
        expect(json_response[0][:title]).to eq('Bar Post')
      end

      it 'returns the last visible item' do
        expect(json_response[-1][:title]).to eq('Baz Post')
      end
    end

    describe 'with visible items (`?filter[visible]=0`)' do
      before do
        get '/posts', params: { filters: { visible: 0 } },
                      headers: { accept: 'application/json' }
      end

      it 'returns the first invisible item' do
        expect(json_response[0][:title]).to eq('Bat Post')
      end

      it 'returns the last invisible item' do
        expect(json_response[-1][:title]).to eq('Foo Post')
      end
    end
  end
end
