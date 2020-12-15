require 'spec_helper'

RSpec.describe Transfer do
  describe 'Relations' do
    it { is_expected.to belong_to(:post).optional }
    it { is_expected.to have_many(:movements) }
    it { is_expected.to have_many(:events) }
  end
end
