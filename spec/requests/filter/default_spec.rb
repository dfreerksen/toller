# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Post filtering', type: :request do
  before do
    Post.create(title: 'Foo Post', deleted_at: 1.week.ago)
    Post.create(title: 'Bar Post', deleted_at: 1.minute.ago)
    Post.create(title: 'Bat Post')
    Post.create(title: 'Baz Post')
  end

  describe 'when no filters are set in URL params' do
    before do
      get '/posts', headers: { accept: 'application/json' }
    end

    it 'returns the first item first' do
      expect(json_response[0][:title]).to eq('Bat Post')
    end

    it 'returns the last item last' do
      expect(json_response[-1][:title]).to eq('Baz Post')
    end
  end
end
