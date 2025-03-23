module WithTransferParams
  def transfer_params
    permitted_transfer_params = [
      :destination,
      :amount,
      :reason,
      :post_id
    ]

    permitted_transfer_params.push(:source) if admin?

    params.
      require(:transfer).
      permit(*permitted_transfer_params)
  end
end
