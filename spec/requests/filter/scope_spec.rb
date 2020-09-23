# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Post filtering', type: :request do
  before do
    Post.create(body: 'Foo post body')
    Post.create(body: 'Bar post body')
  end

  describe 'when filtering by `body_contains` scope' do
    describe 'with items (`?filter[body_contains]=foo`)' do
      before do
        get '/posts', params: { filters: { body_contains: 'foo' } },
                      headers: { accept: 'application/json' }
      end

      it 'returns the first visible item' do
        expect(json_response[0][:body]).to eq('Foo post body')
      end

      it 'returns specific item count' do
        expect(json_response.size).to eq(1)
      end
    end

    describe 'with items (`?filter[body_contains]=blah`)' do
      before do
        get '/posts', params: { filters: { body_contains: 'blah' } },
                      headers: { accept: 'application/json' }
      end

      it 'returns no results' do
        expect(json_response.size).to eq(0)
      end
    end
  end
end
