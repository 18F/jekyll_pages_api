describe JekyllPagesApi::Page do
  describe '#url' do
    it "returns the path" do
      site = instance_double(Jekyll::Site, baseurl: Jekyll::Configuration::DEFAULTS['baseurl'])
      jekyll_page = instance_double(Jekyll::Page, site: site, url: '/foo/')
      page = JekyllPagesApi::Page.new(jekyll_page)

      expect(page.url).to eq('/foo/')
    end

    it "prepends the baseurl" do
      site = instance_double(Jekyll::Site, baseurl: '/base')
      jekyll_page = instance_double(Jekyll::Page, site: site, url: '/foo/')
      page = JekyllPagesApi::Page.new(jekyll_page)

      expect(page.url).to eq('/base/foo/')
    end
  end
end
