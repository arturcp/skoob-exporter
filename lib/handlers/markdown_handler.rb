# lib/handlers/markdown_handler.rb

module Handlers
  class MarkdownHandler
    def call(template, source)
      markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)

      "#{markdown.render(source).inspect}.html_safe"
    end
  end
end
