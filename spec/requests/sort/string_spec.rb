# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Post sorting', type: :request do
  before do
    Post.create(title: 'First Post')
    Post.create(title: 'Second Post')
  end

  describe 'when sorting by `title` string' do
    describe 'with ascending order (`?sort=title`)' do
      it 'returns the first item first' do
        get '/posts', params: { sort: 'title' },
                      headers: { accept: 'application/json' }

        expect(json_response[0][:title]).to eq('First Post')
      end

      it 'returns the last item last' do
        get '/posts', params: { sort: 'title' },
                      headers: { accept: 'application/json' }

        expect(json_response[-1][:title]).to eq('Second Post')
      end
    end

    describe 'with descending order (`?sort=-title`)' do
      it 'returns the first item last' do
        get '/posts', params: { sort: '-title' },
                      headers: { accept: 'application/json' }

        expect(json_response[0][:title]).to eq('Second Post')
      end

      it 'returns the last item first' do
        get '/posts', params: { sort: '-title' },
                      headers: { accept: 'application/json' }

        expect(json_response[-1][:title]).to eq('First Post')
      end
    end
  end

  describe 'when sorting by alias `post_title`' do
    describe 'with ascending order (`?sort=post_title`)' do
      it 'returns the first item first' do
        get '/posts', params: { sort: 'post_title' },
                      headers: { accept: 'application/json' }

        expect(json_response[0][:title]).to eq('First Post')
      end

      it 'returns the last item last' do
        get '/posts', params: { sort: 'post_title' },
                      headers: { accept: 'application/json' }

        expect(json_response[-1][:title]).to eq('Second Post')
      end
    end

    describe 'with descending order (`?sort=-post_title`)' do
      it 'returns the first item last' do
        get '/posts', params: { sort: '-post_title' },
                      headers: { accept: 'application/json' }

        expect(json_response[0][:title]).to eq('Second Post')
      end

      it 'returns the last item first' do
        get '/posts', params: { sort: '-post_title' },
                      headers: { accept: 'application/json' }

        expect(json_response[-1][:title]).to eq('First Post')
      end
    end
  end

  describe 'when sorting by defined scope `the_title`' do
    describe 'with ascending order (`?sort=the_title`)' do
      it 'returns the first item first' do
        get '/posts', params: { sort: 'the_title' },
                      headers: { accept: 'application/json' }

        expect(json_response[0][:title]).to eq('First Post')
      end

      it 'returns the last item last' do
        get '/posts', params: { sort: 'the_title' },
                      headers: { accept: 'application/json' }

        expect(json_response[-1][:title]).to eq('Second Post')
      end
    end

    describe 'with descending order (`?sort=-the_title`)' do
      it 'returns the first item last' do
        get '/posts', params: { sort: '-the_title' },
                      headers: { accept: 'application/json' }

        expect(json_response[0][:title]).to eq('Second Post')
      end

      it 'returns the last item first' do
        get '/posts', params: { sort: '-the_title' },
                      headers: { accept: 'application/json' }

        expect(json_response[-1][:title]).to eq('First Post')
      end
    end
  end

  describe 'when sorting with custom defined scope_name `my_title`' do
    describe 'with ascending order (`?sort=my_title`)' do
      it 'returns the first item first' do
        get '/posts', params: { sort: 'my_title' },
                      headers: { accept: 'application/json' }

        expect(json_response[0][:title]).to eq('First Post')
      end

      it 'returns the last item last' do
        get '/posts', params: { sort: 'my_title' },
                      headers: { accept: 'application/json' }

        expect(json_response[-1][:title]).to eq('Second Post')
      end
    end

    describe 'with descending order (`?sort=-my_title`)' do
      it 'returns the first item last' do
        get '/posts', params: { sort: '-my_title' },
                      headers: { accept: 'application/json' }

        expect(json_response[0][:title]).to eq('Second Post')
      end

      it 'returns the last item first' do
        get '/posts', params: { sort: '-my_title' },
                      headers: { accept: 'application/json' }

        expect(json_response[-1][:title]).to eq('First Post')
      end
    end
  end
end
