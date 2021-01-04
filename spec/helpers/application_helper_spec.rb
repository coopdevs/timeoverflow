RSpec.describe ApplicationHelper do
  it 'avatar_url returns url to gravatar' do
    user = Fabricate(:user)
    gravatar_id = Digest::MD5::hexdigest(user.email).downcase
    expect(helper.avatar_url(user, 50)).to eq("https://www.gravatar.com/avatar/#{gravatar_id}.png?d=identicon&gravatar=hashed&set=set1&size=50x50")
  end

  describe 'seconds_to_hm' do
    it 'with 0 returns em dash' do
      expect(helper.seconds_to_hm(0)).to eq("&mdash;")
    end

    it 'with non-zero returns specific format' do
      expect(helper.seconds_to_hm(10)).to eq("0:00")
      expect(helper.seconds_to_hm(60)).to eq("0:01")
      expect(helper.seconds_to_hm(-60)).to eq("-0:01")
      expect(helper.seconds_to_hm(3600)).to eq("1:00")
    end
  end

  it 'alert_class returns specific error classes' do
    expect(helper.alert_class('error')).to eq('alert-danger')
    expect(helper.alert_class('alert')).to eq('alert-danger')
    expect(helper.alert_class('notice')).to eq('alert-success')
    expect(helper.alert_class('foo')).to eq('alert-info')
  end
end
