# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Post sorting', type: :request do
  before do
    Post.create(title: 'Foo Post')
    Post.create(title: 'Bar Post')
  end

  describe 'when sorting by `title` string' do
    describe 'with ascending order (`?sort=title`)' do
      before do
        get '/posts', params: { sort: 'title' },
                      headers: { accept: 'application/json' }
      end

      it 'returns the first item first' do
        expect(json_response[0][:title]).to eq('Bar Post')
      end

      it 'returns the last item last' do
        expect(json_response[-1][:title]).to eq('Foo Post')
      end
    end

    describe 'with descending order (`?sort=-title`)' do
      before do
        get '/posts', params: { sort: '-title' },
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

  describe 'when sorting by alias `post_title`' do
    describe 'with ascending order (`?sort=post_title`)' do
      before do
        get '/posts', params: { sort: 'post_title' },
                      headers: { accept: 'application/json' }
      end

      it 'returns the first item first' do
        expect(json_response[0][:title]).to eq('Bar Post')
      end

      it 'returns the last item last' do
        expect(json_response[-1][:title]).to eq('Foo Post')
      end
    end

    describe 'with descending order (`?sort=-post_title`)' do
      before do
        get '/posts', params: { sort: '-post_title' },
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
