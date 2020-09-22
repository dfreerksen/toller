# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Post sorting', type: :request do
  before do
    Post.create(title: 'Foo Post', published_at: 1.week.ago)
    Post.create(title: 'Bar Post', published_at: 1.day.ago)
  end

  describe 'when sorting by `published_at` datetime' do
    describe 'with ascending order (`?sort=published_at`)' do
      it 'returns the first item first' do
        get '/posts', params: { sort: 'published_at' },
                      headers: { accept: 'application/json' }

        expect(json_response[0][:title]).to eq('Foo Post')
      end

      it 'returns the last item last' do
        get '/posts', params: { sort: 'published_at' },
                      headers: { accept: 'application/json' }

        expect(json_response[-1][:title]).to eq('Bar Post')
      end
    end

    describe 'with descending order (`?sort=-published_at`)' do
      it 'returns the first item last' do
        get '/posts', params: { sort: '-published_at' },
                      headers: { accept: 'application/json' }

        expect(json_response[0][:title]).to eq('Bar Post')
      end

      it 'returns the last item first' do
        get '/posts', params: { sort: '-published_at' },
                      headers: { accept: 'application/json' }

        expect(json_response[-1][:title]).to eq('Foo Post')
      end
    end
  end
end
