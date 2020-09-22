# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Post filtering', type: :request do
  before do
    Post.create(title: 'Foo Post', body: 'Foo post body')
    Post.create(title: 'Bar Post', body: 'Bar post body')
  end

  describe 'when filtering by `body` text' do
    describe 'with items (`?filter[body]=Foo post body`)' do
      it 'returns the first visible item' do
        get '/posts', params: { filters: { body: 'Foo post body' } },
                      headers: { accept: 'application/json' }

        expect(json_response[0][:body]).to eq('Foo post body')
      end

      it 'returns specific item count' do
        get '/posts', params: { filters: { body: 'Foo post body' } },
                      headers: { accept: 'application/json' }

        expect(json_response.size).to eq(1)
      end
    end
  end
end
