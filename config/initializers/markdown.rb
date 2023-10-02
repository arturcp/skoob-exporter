require 'handlers/markdown_handler'

ActionView::Template.register_template_handler :md, Handlers::MarkdownHandler.new
