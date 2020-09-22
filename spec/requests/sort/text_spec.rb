# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Post sorting', type: :request do
  before do
    Post.create(body: 'Foo post body')
    Post.create(body: 'Bar post body')
  end

  describe 'when sorting by `body` text' do
    describe 'with ascending order (`?sort=body`)' do
      it 'returns the first item first' do
        get '/posts', params: { sort: 'body' },
                      headers: { accept: 'application/json' }

        expect(json_response[0][:body]).to eq('Bar post body')
      end

      it 'returns the last item last' do
        get '/posts', params: { sort: 'body' },
                      headers: { accept: 'application/json' }

        expect(json_response[-1][:body]).to eq('Foo post body')
      end
    end

    describe 'with descending order (`?sort=-body`)' do
      it 'returns the first item last' do
        get '/posts', params: { sort: '-body' },
                      headers: { accept: 'application/json' }

        expect(json_response[0][:body]).to eq('Foo post body')
      end

      it 'returns the last item first' do
        get '/posts', params: { sort: '-body' },
                      headers: { accept: 'application/json' }

        expect(json_response[-1][:body]).to eq('Bar post body')
      end
    end
  end
end
