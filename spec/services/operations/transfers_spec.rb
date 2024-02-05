RSpec.describe Operations::Transfers do
  describe 'create' do
    let(:operation) {
      Operations::Transfers.create(
        from: from,
        to: to,
        transfer_params: {}
      )
    }

    context 'when there is one source and many targets' do
      let(:from) { [1] }
      let(:to) { [2, 3] }

      it 'instantiates a OneToMany operation' do
        expect(operation).to be_a(Operations::Transfers::OneToMany)
      end
    end


    context 'when there many sources and one target' do
      let(:from) { [1, 2] }
      let(:to) { [3] }

      it 'instantiates a ManyToOne operation' do
        expect(operation).to be_a(Operations::Transfers::ManyToOne)
      end
    end

    context 'when weird shit is passed' do
      let(:from) { [] }
      let(:to) { [] }

      it do
        expect { operation }.to raise_error(ArgumentError)
      end
    end
  end
end

