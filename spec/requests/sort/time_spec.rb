# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Post sorting', type: :request do
  before do
    Post.create(title: 'Foo Post', expiration_time: '15:30:45')
    Post.create(title: 'Bar Post', expiration_time: '03:41:18')
  end

  describe 'when sorting by `expiration_time` time' do
    describe 'with ascending order (`?sort=expiration_time`)' do
      before do
        get '/posts', params: { sort: 'expiration_time' },
                      headers: { accept: 'application/json' }
      end

      it 'returns the first item first' do
        expect(json_response[0][:title]).to eq('Bar Post')
      end

      it 'returns the last item last' do
        expect(json_response[-1][:title]).to eq('Foo Post')
      end
    end

    describe 'with descending order (`?sort=-expiration_time`)' do
      before do
        get '/posts', params: { sort: '-expiration_time' },
                      headers: { accept: 'application/json' }
      end

      it 'returns the first item last' do
        expect(json_response[0][:title]).to eq('Foo Post')
      end

      it 'returns the last item first' do
        expect(json_response[-1][:title]).to eq('Bar Post')
      end
    end
  end
end
