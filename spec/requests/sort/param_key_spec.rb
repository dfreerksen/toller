# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Article ordering', type: :request do
  before do
    Post.create(title: 'Foo Post')
    Post.create(title: 'Bar Post')
  end

  describe 'using custom param key (`sorting`) when ordering by `title` string' do
    describe 'with items (`?sorting=title`)' do
      before do
        get '/articles', params: { sorting: 'title' },
                         headers: { accept: 'application/json' }
      end

      it 'returns the first item' do
        expect(json_response[0][:title]).to eq('Bar Post')
      end

      it 'returns the last item' do
        expect(json_response[-1][:title]).to eq('Foo Post')
      end
    end
  end
end
