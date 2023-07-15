# frozen_string_literal: true

RSpec.describe Skoob, type: :model do
  describe '.fetch_publications!' do
    context 'with valid user credentials' do
      let(:user) { create(:skoob_user, skoob_user_id: 123) }

      it 'imports the library publications' do
        publications = double('Publications')

        allow(user).to receive(:import_library).and_yield(user)
        allow(Publications).to receive(:new).with(user).and_return(publications)
        expect(publications).to receive(:import)

        Skoob.fetch_publications!(user)
      end
    end

    context 'with invalid user credentials' do
      let(:user) { create(:skoob_user, skoob_user_id: 0) }

      it 'raises an InvalidCredentialsError' do
        expect { Skoob.fetch_publications!(user) }
          .to raise_error(InvalidCredentialsError, 'Invalid credentials')
      end
    end
  end
end
