module Operations
  module Transfers
    # Transfer operation factory. Creates either a OneToOne/ManyToOne/OneToMany
    # depending on the length of the "from" and "to" arrays
    def create(from:, to:, transfer_params:)
      transfer_klass(from: from, to: to).new(
        from: from,
        to: to,
        transfer_params: transfer_params
      )
    end

    def transfer_klass(from:, to:)
      case
      when from.length == 1 && to.length == 1
        OneToOne
      when from.length > 1 && to.length == 1
        ManyToOne
      when from.length == 1 && to.length > 1
        OneToMany
      else
        raise ArgumentError, "Unknown type of transfer"
      end
    end

    module_function :transfer_klass, :create
    private_class_method :transfer_klass
  end
end
