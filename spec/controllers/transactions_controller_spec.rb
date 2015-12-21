require 'rails_helper'

RSpec.describe TransactionsController, type: :controller do
  let(:valid_attributes) {{
    amount: '100',
    transaction_type: 'withdraw'
  }}

  let(:invalid_attributes) {{
    amount: '0',
    transaction_type: 'withdraw'
  }}

  let(:current_user) { User.create(first_name: 'Bill', last_name: 'Miller', email: 'bill.miller@example.com', password: 'password') }

  before do
    sign_in_as(current_user)
  end

  describe "GET #index" do
    it "gets the transactions for the current_user" do
      expect(current_user).to receive_message_chain(:transactions, :where)
      get :index
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new transaction" do
        expect {
          post :create, {:transaction => valid_attributes}
        }.to change(Transaction, :count).by(1)
      end

      it "assigns a newly created transaction as @transaction" do
        post :create, {:transaction => valid_attributes}
        expect(assigns(:transaction)).to be_a(Transaction)
        expect(assigns(:transaction)).to be_persisted
      end

      it "redirects to the transaction path" do
        post :create, {:transaction => valid_attributes}
        expect(response).to redirect_to(transactions_path)
      end
    end

    context "with invalid params" do
      before do
        request.env["HTTP_REFERER"] = "back"
      end

      it "assigns a newly created but unsaved transaction as @transaction" do
        post :create, {:transaction => invalid_attributes}
        expect(assigns(:transaction)).to be_a_new(Transaction)
      end

      it "re-renders the 'new' template" do
        post :create, {:transaction => invalid_attributes}
        expect(response).to redirect_to("back")
      end
    end
  end

  describe "GET #withdraw" do
    it "assigns a new transaction as @transaction" do
      get :withdraw
      expect(assigns(:transaction)).to be_a_new(Transaction)
    end

    it "assigns a new transaction with transaction_type of withdraw" do
      get :withdraw
      expect(assigns(:transaction).transaction_type).to eq('withdraw')
    end

    it "returns http success" do
      get :withdraw
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #pay" do
    it "assigns a new transaction as @transaction" do
      get :pay
      expect(assigns(:transaction)).to be_a_new(Transaction)
    end

    it "assigns a new transaction with transaction_type of pay" do
      get :pay
      expect(assigns(:transaction).transaction_type).to eq('pay')
    end

    it "returns http success" do
      get :pay
      expect(response).to have_http_status(:success)
    end
  end

end
