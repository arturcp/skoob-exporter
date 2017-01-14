class Book
  include ActiveModel::Model

  attr_accessor :id, :livro_id, :titulo, :nome_portugues, :subtitulo,
    :subtitulo_portugues, :idioma, :mes, :ano, :volume, :serie, :autor, :isbn,
    :paginas, :edicao, :editora, :sinopse, :capitulo_url, :capa_grande,
    :capa_media, :capa_pequena, :capa_mini, :capa_micro, :capa_nano, :img_url,
    :url, :preco_min, :preco_max, :preco_off

  def title
    titulo
  end

  def author
    autor
  end

  def publisher
    editora
  end

  def year
    ano
  end
end
