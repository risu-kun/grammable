require 'rails_helper'

RSpec.describe GramsController, type: :controller do

  describe "grams#index action" do
    it "should successfully show the page" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "grams#new action" do
    it "should require users to be logged in" do
      get :new
      expect(response).to redirect_to new_user_session_path
    end

    it "should successfully show the new form" do
      user = FactoryGirl.create(:user)
      sign_in user

      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "grams#create action" do
    it "should require users to be logged in" do
      post :create, gram: {message: "Hello"}
      expect(response).to redirect_to new_user_session_path
    end

    it "should successfully create a gram in the database" do
      user = FactoryGirl.create(:user)
      sign_in user
      
      post :create, gram: {
                        message: 'Hello!',
                        picture: fixture_file_upload("/little_prince.jpg", 'image/jpg')
                      }

      expect(response).to redirect_to root_path

      gram = Gram.last
      expect(gram.message).to eq("Hello!")
      expect(gram.user).to eq(user)
    end

    it "should properly deal with validation errors" do
      user = FactoryGirl.create(:user)
      sign_in user

      gram_count = Gram.count
      post :create, gram: {message: ''}
      expect(response).to have_http_status(:unprocessable_entity)
      expect(gram_count).to eq Gram.count
    end
  end

  describe "grams#show action" do
    it "should successfully show the page if the gram is found" do
      gram = FactoryGirl.create(:gram)

      get :show, id: gram.id
      expect(response).to have_http_status(:success)
    end

    it "should return a 404 error if the gram is not found" do
      get :show, id: 'this_is_not_a_valid_id'
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "gram#edit" do
    it "should not let a user who did not create the gram edit it" do
      gram = FactoryGirl.create(:gram)
      user = FactoryGirl.create(:user)
      sign_in user

      get :edit, id: gram.id
      expect(response).to have_http_status(:forbidden)
    end

    it "should not let unauthenticated users edit a gram" do
      gram = FactoryGirl.create(:gram)
      get :edit, id: gram.id
      expect(response).to redirect_to new_user_session_path
    end

    it "should successfully show the edit form if the gram is found" do
      gram = FactoryGirl.create(:gram)
      sign_in gram.user
      get :edit, id: gram.id
      expect(response).to have_http_status(:success)
    end

    it "should return a 404 error message if the gram is not found" do
      user = FactoryGirl.create(:user)
      sign_in user
      get :edit, id: 'this_is_not_a_valid_id'
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "gram#update" do
    it "should not let a user who did not create the gram update it" do
      gram = FactoryGirl.create(:gram)
      user = FactoryGirl.create(:user)
      sign_in user

      patch :update, id: gram.id, gram: { message: 'Edited by someone else'}
      expect(response).to have_http_status(:forbidden)
    end

    it "should not let unauthenticated users create a gram" do
      gram = FactoryGirl.create(:gram)
      patch :update, id: gram.id, gram: { message: "Hello" }
      expect(response).to redirect_to new_user_session_path
    end

    it "should successfully update the gram if the gram is found" do
      gram = FactoryGirl.create(:gram, message: "Initial value")
      sign_in gram.user

      patch :update, id: gram.id, gram: { message: "Changed" }

      expect(response).to redirect_to root_path

      gram.reload
      expect(gram.message).to eq("Changed")
    end

    it "should return a 404 error if the gram is not found" do
      user = FactoryGirl.create(:user)
      sign_in user

      patch :update, id: "this_is_not_a_valid_id", gram: { message: "Changed"}

      expect(response).to have_http_status(:not_found)
    end

    it "should redirect to the edit form if validations don't pass" do
      gram = FactoryGirl.create(:gram, message: "Initial Value")
      
      sign_in gram.user
      patch :update, id: gram.id, gram: { message: ""}
      expect(response).to have_http_status(:unprocessable_entity)

      gram.reload
      expect(gram.message).to eq "Initial Value"
    end
  end

  describe "grams#destroy" do
    it "should not let a user who did not create the gram update it" do
      gram = FactoryGirl.create(:gram)
      user = FactoryGirl.create(:user)
      sign_in user

      delete :destroy, id: gram.id
      expect(response).to have_http_status(:forbidden)
    end

    it "should not allow an unauthenticated user to destroy a gram" do
      gram = FactoryGirl.create(:gram)
      delete :destroy, id: gram.id
      expect(response).to redirect_to new_user_session_path
    end

    it "should allow a user to destroy a gram" do
      gram = FactoryGirl.create(:gram)

      sign_in gram.user
      delete :destroy, id: gram.id

      expect(response).to redirect_to root_path

      expect(Gram.find_by_id(gram.id)).to eq nil
    end

    it "should return a 404 message if the gram is not found" do
      user = FactoryGirl.create(:user)
      sign_in user
      delete :destroy, id: "this_is_not_a_valid_id"
      expect(response).to have_http_status(:not_found)
    end
  end 
end
