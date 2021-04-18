RSpec.describe Movement do
  let(:transfer) { Fabricate(:transfer) }

  it "#other_side returns the other movement from same transfer" do
    mov = transfer.movements.first
    mov_other_side = mov.other_side

    expect(mov_other_side).not_to eq(mov)
    expect(mov_other_side.amount).to eq(-mov.amount)
    expect(mov_other_side.transfer).to eq(mov.transfer)
  end
end
