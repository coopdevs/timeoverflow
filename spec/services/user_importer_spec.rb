RSpec.describe UserImporter do
  describe '#call' do
    let(:organization) { Fabricate(:organization) }
    let(:user) do
      User.new(
        username: 'Hermione Cadena Muñoz',
        date_of_birth: '1989-03-16',
        email: 'user@example.com',
        phone: '622743103',
        alt_phone: '691777984',
        gender: 'female'
      )
    end

    # member_id, entry_date, username, gender, date_of_birth, phone, alt_phone, email
    let(:csv_data) { StringIO.new('1,2018-01-30,Hermione,Cadena,Muñoz,1,1989-03-16,622743103,691777984,user@example.com') }

    before do
      I18n.locale = :en

      allow(Organization)
        .to receive(:find).with(organization.id).and_return(organization)

      allow(User).to receive(:new).with(
        username: 'Hermione Cadena Muñoz',
        date_of_birth: '1989-03-16',
        email: 'user@example.com',
        phone: '622743103',
        alt_phone: '691777984',
        gender: 'female',
        locale: :en
      ).and_return(user)
    end

    it 'creates a user out of a CSV row' do
      expect(User).to receive(:new).with(
        username: 'Hermione Cadena Muñoz',
        date_of_birth: '1989-03-16',
        email: 'user@example.com',
        phone: '622743103',
        alt_phone: '691777984',
        gender: 'female',
        locale: :en
      ).and_return(user)

      described_class.call(organization.id, csv_data)
    end

    it 'persists the user' do
      expect(user).to receive(:save)
      described_class.call(organization.id, csv_data)
    end
  end
end
