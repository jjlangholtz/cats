require 'rails_helper'

describe CatsController do
  describe 'GET :index' do
    before { @cats = create_list(:cat, 3) }
    it 'responds with all cats when no ids are sent' do
      get :index, format: :json
      data = JSON.parse(response.body)
      expect(data.size).to eq 3
      expect(data.first).to have_key('name')
      expect(data.first['name']).to eq @cats.first.name
    end

    it 'responds with cats that match the ids sent' do
      get :index, cat_ids: [@cats[1].id, @cats[2].id], format: :json
      data = JSON.parse(response.body)
      expect(data.size).to eq 2
      expect(data.first['name']).to eq @cats.second.name
      expect(data.second['name']).to eq @cats.third.name
    end

    it 'responds with all cats after since id' do
      get :index, since_id: @cats[1].id, format: :json
      data = JSON.parse(response.body)
      expect(data.size).to eq 1
      expect(data.first['name']).to eq @cats.third.name
    end

    it 'serves image urls instead of uids' do
      create(:cat, image: 'cat.jpg')
      get :index, format: :json
      data = JSON.parse(response.body)
      expect(data.fourth).to have_key('image_url')
      expect(data.fourth).not_to have_key('image_uid')
    end

  end

  it 'GET :show' do
    cat = create(:cat)
    get :show, id: cat.id, format: :json
    data = JSON.parse(response.body)
    expect(data).to have_key('name')
    expect(data['name']).to eq cat.name
  end

  describe 'POST :create' do
    before { @cat_attributes = attributes_for(:cat) }
    it 'succeeds when all attributes are set' do
      post_cat :created
      data = JSON.parse(response.body)
      expect(data).to have_key('name')
      expect(data['name']).to eq @cat_attributes[:name]
    end

    it 'fails when a required field is missing' do
      @cat_attributes[:name] = nil
      post_cat :unprocessable_entity
    end

    def post_cat(status)
      post :create, cat: @cat_attributes, format: :json
      expect(response).to have_http_status(status)
    end
  end

  describe 'PATCH :update' do
    before { @cat = create(:cat) }
    it 'succeeds when valid data are changed' do
      patch :update, id: @cat.id, cat: { name: 'Jasmine' }, format: :json
      expect(response).to have_http_status(:no_content)
      expect(Cat.find(@cat.id).name).to eq 'Jasmine'
    end

    it 'fails when a required field is missing' do
      cat_name = @cat.name
      patch :update, id: @cat.id, cat: { name: nil }, format: :json
      expect(response).to have_http_status(:unprocessable_entity)
      expect(Cat.find(@cat.id).name).to eq cat_name
    end
  end

  it 'DELETE :destroy' do
    cat = create(:cat)
    delete :destroy, id: cat.id, format: :json
    expect(response).to have_http_status(:no_content)
    expect{ Cat.find(cat.id) }.to raise_error ActiveRecord::RecordNotFound
  end
end
