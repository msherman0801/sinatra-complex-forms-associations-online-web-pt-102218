class PetsController < ApplicationController

  get '/pets' do
    @pets = Pet.all
    erb :'/pets/index' 
  end

  get '/pets/new' do 
    @owners = Owner.all
    erb :'/pets/new'
  end

  post '/pets' do 
    @pet = Pet.create(params[:pet])
    if !params[:owner_name].empty?
      @pet.owner = Owner.create(name: params[:owner_name])
      @pet.save
    elsif !params[:pet][:owner_id].empty?
      @pet.owner = Owner.find(params[:owner_id])
      @pet.save
    end
    redirect "/pets/#{@pet.id}"
  end

  get '/pets/:id' do 
    @pet = Pet.find(params[:id])
    erb :'/pets/show'
  end

  get '/pets/:id/edit' do
    @owners = Owner.all
    @pet = Pet.find(params[:id])
    erb :'/pets/edit'
  end

  patch '/pets/:id' do
    pet = Pet.find(params[:id])
    owner = Owner.find(params[:pet][:owner_id].first)
    new_owner = Owner.create(name: params[:owner][:name]) if !params[:owner][:name].empty?
    pet.name = params[:pet][:name] if !params[:pet][:name].empty?
    pet.owner = owner if owner != nil
    pet.owner = new_owner if new_owner != nil
    pet.save
    redirect to "pets/#{@pet.id}"
  end
end