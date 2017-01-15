require 'mechanize'

class SkoobUser < ActiveRecord::Base
  has_many :books, primary_key: 'skoob_user_id'

  def self.login(email, password)
    user = find_or_initialize_by(email: email)
    mechanize = user.mechanize

    mechanize.get('https://www.skoob.com.br/login/') do |page|
      form = page.forms[2]
      button = form.button_with(value: 'Entrar')
      form.fields[0].value = email
      form.fields[1].value = password
      next_page = mechanize.submit(form, button)

      unless user.skoob_user_id.present?
        url = next_page.uri.to_s
        slug = url.split('/').last
        user.skoob_user_id = slug.split('-').first
        user.save if user.skoob_user_id > 0
      end
    end

    user
  end

  def import_library
    update(import_status: 1, not_imported: {})

    books = yield(self)

    update(import_status: 0, not_imported: books[:duplicated])
  end

  def mechanize
    @mechanize ||= begin
      mechanize = Mechanize.new { |agent|
        agent.user_agent_alias = 'Mac Safari'
      }

      mechanize.agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      mechanize
    end
  end
end
