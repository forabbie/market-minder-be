require 'rails_helper'

RSpec.describe Stock, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:transaction) }
  end
end
