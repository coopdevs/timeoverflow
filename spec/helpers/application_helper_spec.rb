RSpec.describe ApplicationHelper do
  it 'avatar_url returns url to gravatar' do
    user = Fabricate(:user)
    gravatar_id = Digest::MD5::hexdigest(user.email).downcase
    expect(helper.avatar_url(user, 50)).to eq("https://www.gravatar.com/avatar/#{gravatar_id}.png?d=identicon&gravatar=hashed&set=set1&size=50x50")
  end

  describe 'avatar_url' do
    it 'returns the avatar when it is attached' do
      user = Fabricate(:user)
      filename = "image.png"
      temp_file = Tempfile.new(filename)
      user.avatar.attach(io: File.open(temp_file.path), filename: 'name.png', content_type: 'image/png')
      temp_file.close
      temp_file.unlink
      img = helper.avatar_url(user, 50)

      expect(img.class).to eq(ActiveStorage::VariantWithRecord)
      expect(img.variation.transformations[:resize]).to eq("50x50")
      expect(img.blob.filename).to eq("name.png")
    end

    it 'returns url to gravatar when there is no avatar attached' do
      user = Fabricate(:user)
      gravatar_id = Digest::MD5::hexdigest(user.email).downcase

      expect(helper.avatar_url(user, 50)).to include("www.gravatar.com")
    end
  end

  describe 'seconds_to_hm' do
    it 'with 0 returns the default value' do
      expect(helper.seconds_to_hm(0)).to eq("&mdash;")
      expect(helper.seconds_to_hm(0, 0)).to eq(0)
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
