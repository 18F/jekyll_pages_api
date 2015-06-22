# @author Mike Bland (michael.bland@gsa.gov)

require_relative 'generated_page_parser'

module JekyllPagesApi
  # Used by GeneratedSite to mimic a Jekyll page object when processing an
  # already-generated site using the Generator.
  class GeneratedPage
    attr_reader :path, :relative_path, :data, :content

    # @param basedir see {GeneratedSite#initialize}
    # @param title_prefix see {GeneratedSite#initialize}
    # @param body_element_tag see {GeneratedSite#initialize}
    # @param path [String] full path to the generated page's file
    # @param content [String] HTML content of the generated page's file
    def initialize(basedir, title_prefix, body_element_tag, path, content)
      @path = path
      basedir_len = basedir.size
      basedir_len += 1 if basedir.end_with? File::SEPARATOR

      end_path = path.size
      index_suffix = File.join "", "index.html"
      end_path -= (index_suffix.size + 1) if path.end_with? index_suffix
      @relative_path = path[basedir_len..end_path]
      @data, @content = GeneratedPageParser.parse_generated_page(
        content, title_prefix, body_element_tag)
    end
  end
end
