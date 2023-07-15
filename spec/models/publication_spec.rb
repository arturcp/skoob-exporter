# frozen_string_literal: true

RSpec.describe Publication do
  describe 'associations' do
    it { is_expected.to belong_to(:skoob_user).with_primary_key('skoob_user_id') }
  end

  describe 'enums' do
    it { is_expected.to define_enum_for(:publication_type).with_values(book: 0, comic: 1, magazine: 2) }
  end
end
