class TransfersController < ApplicationController
  include WithTransferParams

  def create
    @source = find_source

    if params[:cross_bank] == "true" && params[:post_id].present?
      post = Post.find(params[:post_id])
      create_cross_bank_transfer(post)
      return
    end

    @account = Account.find(transfer_params[:destination])

    transfer = Transfer.new(
      transfer_params.merge(source: @source, destination: @account)
    )

    persister = ::Persister::TransferPersister.new(transfer)

    if persister.save
      redirect_to redirect_target
    else
      redirect_back fallback_location: redirect_target, alert: transfer.errors.full_messages.to_sentence
    end
  end

  def new
    transfer_factory = TransferFactory.new(
      current_organization,
      current_user,
      params[:offer],
      params[:destination_account_id],
      params[:cross_bank] == "true"
    )

    @cross_bank = params[:cross_bank] == "true"
    @offer = transfer_factory.offer

    render(
      :new,
      locals: {
        accountable: transfer_factory.accountable,
        transfer: transfer_factory.build_transfer,
        offer: transfer_factory.offer,
        sources: transfer_factory.transfer_sources,
        cross_bank: @cross_bank
      }
    )
  end

  def delete_reason
    @transfer = Transfer.find(params[:id])
    @transfer.update_columns(reason: nil)

    respond_to do |format|
      format.json { head :ok }
      format.html { redirect_back(fallback_location: request.referer) }
    end
  end

  private

  def create_cross_bank_transfer(post)
    transfer_factory = TransferFactory.new(
      current_organization,
      current_user,
      post.id,
      nil,
      true
    )

    transfer = transfer_factory.build_transfer
    transfer.amount = transfer_params[:amount]
    transfer.reason = transfer_params[:reason]

    persister = ::Persister::TransferPersister.new(transfer)

    if persister.save
      redirect_to post, notice: t('transfers.cross_bank.success')
    else
      redirect_back fallback_location: post, alert: transfer.errors.full_messages.to_sentence
    end
  end

  def find_source
    if admin?
      Account.find(transfer_params[:source])
    else
      current_user.members.find_by(organization: current_organization).account
    end
  end

  def redirect_target
    case accountable = @account.accountable
    when Organization
      accountable
    when Member
      accountable.user
    else
      raise ArgumentError
    end
  end
end
