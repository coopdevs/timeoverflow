class MultiTransfersController < ApplicationController
  include WithTransferParams

  STEPS = [
    'select_type',
    'select_source',
    'select_target',
    'set_params',
    'confirm'
  ]

  def step
    authorize :multi_transfer

    set_steps_info
    propagate_params
    prepare_template_vars
  end

  def create
    authorize :multi_transfer

    operation = Operations::Transfers.create(
      from: params[:from],
      to: params[:to],
      transfer_params: params[:transfer].to_unsafe_h
    )
    operation.perform
  end

  private

  def set_steps_info
    @steps = STEPS
    @step_name = step_name
    @form_action = if @step_name == @steps.last
                     multi_transfers_create_path
                   else
                     multi_transfers_step_path(step: next_step)
                   end
    @is_last_step = is_last_step
  end

  def propagate_params
    @type_of_transfer = (params[:type_of_transfer] || :many_to_one).to_sym
    @from = params[:from] || []
    @to = params[:to] || []

    @transfer_amount = params[:transfer] && params[:transfer][:amount]
    @transfer_post_id = params[:transfer] && params[:transfer][:post_id]
    @transfer_reason = params[:transfer] && params[:transfer][:reason]
    @transfer_minutes = params[:transfer] && params[:transfer][:minutes]
    @transfer_hours = params[:transfer] && params[:transfer][:hours]
  end

  def prepare_template_vars
    @accounts = [current_organization.account] + current_organization.member_accounts.merge(Member.active)

    if @type_of_transfer == :many_to_one && @to.length == 1
      @target_accountable = Account.find(@to.first).accountable
    end

    @should_render_offer_selector = (
      @type_of_transfer.to_sym == :many_to_one &&
      @target_accountable &&
      @target_accountable.offers.length > 0
    )

    @from_names = Account.find(@from).map(&:accountable).map(&:to_s)
    @to_names = Account.find(@to).map(&:accountable).map(&:to_s)
    @post_title = @transfer_post_id && Post.find(@transfer_post_id).title
  end

  def step_index
    params[:step].to_i - 1
  end

  def next_step
    params[:step].to_i + 1
  end

  def step_name
    STEPS[step_index]
  end

  def is_last_step
    step_index == STEPS.length - 1
  end
end
