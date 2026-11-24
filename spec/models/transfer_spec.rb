RSpec.describe Transfer do
  describe 'Relations' do
    it { is_expected.to belong_to(:post).optional }
    it { is_expected.to have_many(:movements) }
    it { is_expected.to have_many(:events) }
  end

  describe 'amount validation' do
    let(:source) { Fabricate(:account) }
    let(:destination) { Fabricate(:account) }

    def transfer_with(amount)
      Transfer.new(source: source, destination: destination, amount: amount)
    end

    it 'accepts whole minutes' do
      expect(transfer_with(60)).to be_valid
      expect(transfer_with('5400')).to be_valid
    end

    it 'rejects amounts below one minute, which display as 0:00' do
      [0, 1, 30, 59].each do |amount|
        expect(transfer_with(amount)).not_to be_valid
      end
    end

    it 'rejects fractional amounts' do
      expect(transfer_with(90.5)).not_to be_valid
      expect(transfer_with('1800.5')).not_to be_valid
    end

    it 'rejects missing and non numeric amounts' do
      expect(transfer_with(nil)).not_to be_valid
      expect(transfer_with('NaN')).not_to be_valid
    end
  end

  describe 'movements' do
    it 'creates one movement per account that sum zero' do
      transfer = Fabricate(:transfer, amount: 3600)

      expect(transfer.movements.pluck(:amount)).to contain_exactly(-3600, 3600)
    end
  end
end
