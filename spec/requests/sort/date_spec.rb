# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Post sorting', type: :request do
  before do
    Post.create(title: 'Foo Post', expiration_date: '1776-07-04')
    Post.create(title: 'Bar Post', expiration_date: '1979-11-24')
  end

  describe 'when sorting by `expiration_date` date' do
    describe 'with ascending order (`?sort=expiration_date`)' do
      it 'returns the first item first' do
        get '/posts', params: { sort: 'expiration_date' },
                      headers: { accept: 'application/json' }

        expect(json_response[0][:title]).to eq('Foo Post')
      end

      it 'returns the last item last' do
        get '/posts', params: { sort: 'expiration_date' },
                      headers: { accept: 'application/json' }

        expect(json_response[-1][:title]).to eq('Bar Post')
      end
    end

    describe 'with descending order (`?sort=-expiration_date`)' do
      it 'returns the first item last' do
        get '/posts', params: { sort: '-expiration_date' },
                      headers: { accept: 'application/json' }

        expect(json_response[0][:title]).to eq('Bar Post')
      end

      it 'returns the last item first' do
        get '/posts', params: { sort: '-expiration_date' },
                      headers: { accept: 'application/json' }

        expect(json_response[-1][:title]).to eq('Foo Post')
      end
    end
  end
end
