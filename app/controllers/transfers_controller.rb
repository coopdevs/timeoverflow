class TransfersController < ApplicationController
  # GET /transfers
  # GET /transfers.json
  def index
    @transfers = Transfer.all
  end

  def show
    @transfer = Transfer.find(params[:id])
  end

  def edit
    @transfer = Transfer.find(params[:id])
  end

  def new
    @transfer = Transfer.new
    @transfer.inbound_movement = InboundMovement.new
    @transfer.outbound_movement = OutboundMovement.new
  end

  def create
    @Transfer = Transfer.new(params[:transfer])

    if @Transfer.save
      render json: @Transfer, status: :created, location: @Transfer
    else
      render json: @Transfer.errors, status: :unprocessable_entity
    end
  end

  def update
    if @transfer.update_attributes params[:trasnfer]
      respond_with @transfer
    else
      respond_with @transfer, status: :unprocessable_entity
    end
  end

  def destroy
    @transfer = Transfer.find(params[:id])
    @transfer.destroy
  end

  private

    # Use this method to whitelist the permissible parameters. Example:
    # params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
   # def transfer_params
    #  params.require(:transfer).permit(:amount, :category, :date, :user)
    #end
end
