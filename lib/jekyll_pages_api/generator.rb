require_relative 'filterer'
require_relative 'page_without_a_file'

module JekyllPagesApi
  class Generator
    attr_reader :site

    def initialize(site)
      @site = site
    end

    def filterer
      @filterer ||= Filterer.new
    end

    def pages
      self.site.pages.select {|page| %w(.html .md).include?(page.ext) }
    end

    def get_output(page)
      result = self.filterer.strip_html(page.content)
      result = self.filterer.condense(result)
      filterer.decode_html(result)
    end

    def pages_data
      self.pages.map do |page|
        title = page.data['title'] || ''
        {
          title: self.filterer.decode_html(title),
          url: page.url,
          body: self.get_output(page)
        }
      end
    end

    def data
      {
        entries: pages_data
      }
    end

    def dest_dir
      File.join('api', 'v1')
    end

    def page
      # based on https://github.com/jekyll/jekyll-sitemap/blob/v0.7.0/lib/jekyll-sitemap.rb#L51-L54
      page = PageWithoutAFile.new(self.site, File.dirname(__FILE__), self.dest_dir, 'pages.json')
      page.content = self.data.to_json
      page.data['layout'] = nil
      page.render(Hash.new, self.site.site_payload)

      page
    end

    def generate
      self.site.pages << self.page
    end
  end
end
