# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Post filtering', type: :request do
  before do
    Post.create(title: 'Foo Post', expiration_date: '1775-11-10')
    Post.create(title: 'Bar Post', expiration_date: '1776-07-04')
    Post.create(title: 'Bat Post', expiration_date: '1845-12-29')
    Post.create(title: 'Baz Post', expiration_date: '2020-05-25')
  end

  describe 'when filtering by `expiration_date` date' do
    describe 'with specific expiration_date items (`?filter[expiration_date]=1776/07/04`)' do
      before do
        get '/posts', params: { filters: { expiration_date: '1776/07/04' } },
                      headers: { accept: 'application/json' }
      end

      it 'returns the first item' do
        expect(json_response[0][:title]).to eq('Bar Post')
      end

      it 'returns a specific count' do
        expect(json_response.size).to eq(1)
      end
    end

    describe 'with inclusive (..) range of items (`?filter[expiration_date]=1770-01-01..1845-12-29`)' do
      before do
        get '/posts', params: { filters: { expiration_date: '1770/01/01...1845/12/29' } },
                      headers: { accept: 'application/json' }
      end

      it 'returns the first item' do
        expect(json_response[0][:title]).to eq('Bar Post')
      end

      it 'returns the last item' do
        expect(json_response[-1][:title]).to eq('Foo Post')
      end

      it 'returns the last invisible item' do
        expect(json_response.size).to eq(3)
      end
    end

    describe 'with exclusive (...) range of items (`?filter[expiration_date]=1770-01-01...1845-12-29`)' do
      before do
        get '/posts', params: { filters: { expiration_date: '1770/01/01..1845/12/29' } },
                      headers: { accept: 'application/json' }
      end

      it 'returns the first item' do
        expect(json_response[0][:title]).to eq('Bar Post')
      end

      it 'returns the last item' do
        expect(json_response[-1][:title]).to eq('Foo Post')
      end

      it 'returns the last invisible item' do
        expect(json_response.size).to eq(3)
      end
    end
  end
end
