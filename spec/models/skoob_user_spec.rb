# frozen_string_literal: true

RSpec.describe SkoobUser do
  describe '.login' do
    let(:email) { 'test@example.com' }
    let(:password) { 'password123' }
    let(:user) { create(:skoob_user, skoob_user_id: nil) }
    let(:mechanize) { instance_double('Mechanize') }
    let(:page) { instance_double('Mechanize::Page') }
    let(:form) { instance_double('Mechanize::Form') }
    let(:button) { instance_double('Mechanize::Form::Button') }
    let(:next_page) { instance_double('Mechanize::Page') }
    let(:field) { instance_double('Mechanize::Form::Text') }

    before do
      allow(SkoobUser).to receive(:find_or_initialize_by).with(email: email).and_return(user)
      allow(user).to receive(:mechanize).and_return(mechanize)
      allow(mechanize).to receive(:get).and_yield(page)
      allow(page).to receive(:forms).and_return([nil, nil, form])
      allow(form).to receive(:fields).and_return([field, field])
      allow(form).to receive(:button_with).with(value: 'Entrar').and_return(button)
      allow(mechanize).to receive(:submit).with(form, button).and_return(next_page)
      allow(next_page).to receive(:uri).and_return(URI('https://www.skoob.com.br/user/123-example-user'))
      allow(user).to receive(:save)
      allow(field).to receive(:value=)
    end

    it 'logs in the user and sets the skoob_user_id' do
      SkoobUser.login(email, password)

      expect(user.skoob_user_id).not_to be_nil
    end

    it 'raises an error and sends a Slack message if an error occurs' do
      allow(Slack::Message).to receive(:send)
      allow(form).to receive(:fields).and_return([])

      expect {
        SkoobUser.login(email, password)
      }.to raise_error(StandardError)
    end
  end

  describe '#import_library' do
    let(:user) { SkoobUser.new }

    it 'updates the import status and not_imported fields' do
      user.import_library do |skoob_user|
        expect(user.import_status).to eq(1)
        { duplicated: {} }
      end

      expect(user.import_status).to eq(0)
      expect(user.not_imported).to eq({})
    end
  end

  describe '#mechanize' do
    let(:user) { SkoobUser.new }

    it 'returns a Mechanize instance' do
      expect(user.mechanize).to be_a(Mechanize)
    end
  end
end
