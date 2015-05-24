require_relative 'filters'

module JekyllPagesApi
  # wrapper for a Jekyll::Page
  class Page
    HTML_EXTS = %w(.html .md .markdown .textile)
    attr_reader :page

    def initialize(page, site)
      @page = page
      @site = site
    end

    def html?
      path = @page.path
      path.end_with?('/') || HTML_EXTS.include?(File.extname(path))
    end

    def filterer
      @filterer ||= Filters.new
    end

    def title
      title = self.page.data['title'] if self.page.respond_to?(:data)
      title = self.page.title if title == nil and self.page.respond_to?(:title)
      self.filterer.decode_html(title || '')
    end

    def base_url
      @site.baseurl
    end

    def url
      rel_path = self.page.url if self.page.respond_to?(:url)
      if rel_path == nil and self.page.respond_to?(:relative_path)
        rel_path = self.page.relative_path
      end
      [self.base_url, rel_path].join
    end

    def body_text
      output = self.page.content if self.page.respond_to?(:content)
      File.open(self.page.path, 'r') {|f| output = f.read} if output == nil
      self.filterer.text_only(output)
    end

    def tags
      (self.page.data['tags'] if self.page.respond_to?(:data)) || []
    end

    def to_json
      {
        title: self.title,
        url: self.url,
        tags: self.tags,
        body: self.body_text
      }
    end
  end
end
