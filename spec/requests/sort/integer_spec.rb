# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Post sorting', type: :request do
  let(:first) { Post.create(title: 'Foo Post') }
  let(:second) { Post.create(title: 'Bar Post') }

  before do
    first
    second
  end

  describe 'when sorting by `id` integer' do
    describe 'with ascending order (`?sort=id`)' do
      before do
        get '/posts', params: { sort: 'id' },
                      headers: { accept: 'application/json' }
      end

      it 'returns the first item first' do
        expect(json_response[0][:id]).to eq(first.id)
      end

      it 'returns the last item last' do
        expect(json_response[-1][:id]).to eq(second.id)
      end
    end

    describe 'with descending order (`?sort=-id`)' do
      before do
        get '/posts', params: { sort: '-id' },
                      headers: { accept: 'application/json' }
      end

      it 'returns the first item last' do
        expect(json_response[0][:id]).to eq(second.id)
      end

      it 'returns the last item first' do
        expect(json_response[-1][:id]).to eq(first.id)
      end
    end
  end
end
