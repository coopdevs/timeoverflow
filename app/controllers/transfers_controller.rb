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

    destination_organization = transfer_factory.destination_organization

    @persisters = []

    user_account = current_user.members.find_by(organization: current_organization).account
    org_account = current_organization.account

    if user_account.id != org_account.id
      user_to_org_transfer = Transfer.new(
        source: user_account,
        destination: org_account,
        amount: transfer_params[:amount],
        reason: post.description,
        post: post
      )
      @persisters << ::Persister::TransferPersister.new(user_to_org_transfer)
    end

    org_to_org_transfer = Transfer.new(
      source: org_account,
      destination: destination_organization.account,
      amount: transfer_params[:amount],
      reason: post.description,
      post: post,
      is_cross_bank: true
    )
    @persisters << ::Persister::TransferPersister.new(org_to_org_transfer)

    member = post.user.members.find_by(organization: destination_organization)
    if member && member.account
      org_to_user_transfer = Transfer.new(
        source: destination_organization.account,
        destination: member.account,
        amount: transfer_params[:amount],
        reason: post.description,
        post: post
      )
      @persisters << ::Persister::TransferPersister.new(org_to_user_transfer)
    end

    if persisters_saved?
      redirect_to post, notice: t('transfers.cross_bank.success')
    else
      @persisters.each do |persister|
        persister.transfer.destroy if persister.transfer.persisted?
      end
      redirect_back fallback_location: post, alert: @error_messages || t('transfers.cross_bank.error')
    end
  end

  def persisters_saved?
    @error_messages = []

    @persisters.each do |persister|
      unless persister.save
        @error_messages << persister.transfer.errors.full_messages.to_sentence
        return false
      end
    end

    true
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
