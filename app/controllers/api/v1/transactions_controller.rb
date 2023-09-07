class Api::V1::TransactionsController < ApplicationController
  before_action :check_authentication

  #return all transactions
  def index
    @transactions = Transaction.includes(stock: :user).all
    render json: TransactionSerializer.new(@transactions).as_json
  end

  def return_user_transactions
    @transactions = current_user.transactions
    render json: TransactionSerializer.new(@transactions).as_json
  end

  def create
    stock = Stock.check_db(params[:symbol], current_user.id)
    if stock.blank?
      stock = Stock.new_lookup(params[:symbol])
      stock.user_id = current_user.id
      stock.save
    end
    params[:price] = params[:price].blank? ? stock.last_price : params[:price]
    params[:total_price] = params[:shares_quantity] * params[:price]
    if params[:transaction_type] != "sell"
      if current_user.insufficient_balance?(transaction_params)
        render json: { response: "You don't have enough balance." }
      else
        current_user.deduct_balance!(transaction_params)
        stock.add_shares!(transaction_params[:shares_quantity])
        transaction = Transaction.new(transaction_params)
        transaction.stock_id = stock.id
        if transaction.save
          render json: { response: "Successfully bought #{ transaction.shares_quantity } shares"}
        else
          render json: { response: "Purchase Failed" }
        end
      end
    else
      if stock.insufficient_shares?(transaction_params[:shares_quantity])
        render json: { response: "You don't have enough shares" }
      else
        current_user.add_balance!(transaction_params) 
        stock.deduct_shares!(transaction_params[:shares_quantity])
        transaction = Transaction.new(transaction_params)
        transaction.stock_id = stock.id
        if transaction.save
          render json: { response: "Successfully sold #{ transaction.shares_quantity } shares"}
        else
          render json: { response: "Sell Failed" }
        end
      end
    end
  end

  private
  def transaction_params
    params.permit(:shares_quantity, :price, :total_price, :transaction_type)
  end
  
end