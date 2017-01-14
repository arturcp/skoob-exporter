require 'mechanize'

class SkoobUser
  attr_reader :id

  def initialize(email, password)
    @email = email
    @password = password
    @id = 0
  end

  def login
    mechanize.get('https://www.skoob.com.br/login/') do |page|
      form = page.forms[2]
      button = form.button_with(value: 'Entrar')
      form.fields[0].value = @email
      form.fields[1].value = @password
      next_page = mechanize.submit(form, button)
      url = next_page.uri.to_s

      slug = url.split('/').last
      @id = slug.split('-').first
    end

    self
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
