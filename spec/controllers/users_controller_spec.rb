require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:valid_attributes) {{
    first_name: 'joe',
    last_name: 'smoe',
    email: 'joe.smoe@example.com',
    encrypted_password: 'asdasdjh32kjhr23fdsf',
    password: 'password',
    confirmation_token: nil,
    remember_token: '0fa4c7fa1aec8d358b64d857d6d6e6e1492aca3e'
  }}

  let(:invalid_attributes) {{
    first_name: 'karen',
    last_name: 'duds',
    age: '27'
  }}

  let(:valid_session) { {} }

  describe "GET #new" do
    it "assigns a new user as @user" do
      get :new, {}, valid_session
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new User" do
        expect {
          post :create, {:user => valid_attributes}, valid_session
        }.to change(User, :count).by(1)
      end

      it "assigns a newly created user as @user" do
        post :create, {:user => valid_attributes}, valid_session
        expect(assigns(:user)).to be_a(User)
        expect(assigns(:user)).to be_persisted
      end

      it "redirects to the root_path" do
        post :create, {:user => valid_attributes}, valid_session
        expect(response).to redirect_to(root_path)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved user as @user" do
        post :create, {:user => invalid_attributes}, valid_session
        expect(assigns(:user)).to be_a_new(User)
      end

      it "re-renders the 'new' template" do
        post :create, {:user => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end
end
