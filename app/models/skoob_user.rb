require 'mechanize'

class SkoobUser < ActiveRecord::Base
  has_many :books, primary_key: 'skoob_user_id'

  def self.login(email, password)
    user = find_or_initialize_by(email: email)
    mechanize = user.mechanize
    referer = 'https://www.google.com.br'
    headers = {
      ':authority' => 'www.skoob.com.br',
      ':method' => 'POST',
      ':path' => '/login/',
      ':scheme' => 'https',
      'accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9',
      'accept-encoding' => 'gzip, deflate, br',
      'accept-language' => 'en-US,en;q=0.9',
      'cache-control' => 'max-age=0',
      'content-length' => '89',
      'content-type' => 'application/x-www-form-urlencoded',
      'cookie' => 'user_is_logged=0; user_logged=null; __cfduid=d9364dff65988d7dd10571f9828cdaa0a1612714647; PHPSESSID=im1aa7js3q5ohg6fg2ospbcjf7; __asc=a943d4491777d48a61402861724; __auc=a943d4491777d48a61402861724; __utma=33443132.290898526.1612714649.1612714649.1612714649.1; __utmc=33443132; __utmz=33443132.1612714649.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); __utmt=1; user_is_logged=0; user_logged=null; __gads=ID=e734b24ea3f49899-224c06d5cab300cf:T=1612714774:S=ALNI_MZD1NRMRci2GOQlCDUS3TodEvIKIg; __utmb=33443132.2.10.1612714649',
      'origin' => 'https://www.skoob.com.br',
      'referer' => 'https://www.skoob.com.br/login/',
      'sec-ch-ua' => '"Chromium";v="88", "Google Chrome";v="88", ";Not A Brand";v="99"',
      'sec-ch-ua-mobile' => '?0',
      'sec-fetch-dest' => 'document',
      'sec-fetch-mode' => 'navigate',
      'sec-fetch-site' => 'same-origin',
      'sec-fetch-user' => '?1',
      'upgrade-insecure-requests' => '1',
      'user-agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 11_1_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.146 Safari/537.36',
    }

    mechanize.get('https://www.skoob.com.br/login/', [], referer, headers) do |page|
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
        agent.user_agent_alias = Mechanize::AGENT_ALIASES.keys.sample
      }

      mechanize.agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      mechanize
    end
  end
end
