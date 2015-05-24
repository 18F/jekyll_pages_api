BASEURL = Jekyll::Configuration::DEFAULTS['baseurl']

RSpec.shared_context "create page" do
  before { @tmp_dir = '' }
  after { FileUtils.remove_entry(@tmp_dir) if not @tmp_dir.empty? }

  def create_page(baseurl, page_url, data: nil, content: nil)
    site = instance_double(Jekyll::Site, baseurl: baseurl)
    jekyll_page = instance_double(Jekyll::Page, site: site, url: page_url,
      path: page_url)
    allow(jekyll_page).to receive(:data).and_return(data) unless data == nil
    unless content == nil
      allow(jekyll_page).to receive(:content).and_return(content)
    end
    JekyllPagesApi::Page.new(jekyll_page, site)
  end

  def create_static_file(baseurl, relative_path, content: nil)
    site = instance_double(Jekyll::Site, baseurl: baseurl)
    if content == nil
      jekyll_static_file = instance_double(Jekyll::StaticFile,
        relative_path: relative_path)
    else content == nil
      @tmp_root = Dir.mktmpdir
      @static_file_path = File.join(@tmp_root, relative_path)
      FileUtils.mkdir_p(File.dirname(@static_file_path))
      File.open(@static_file_path, 'w') {|f| f << content}

      jekyll_static_file = Jekyll::StaticFile.new(site, @tmp_root,
        File.dirname(relative_path), File.basename(relative_path))
    end
    JekyllPagesApi::Page.new(jekyll_static_file, site)
  end

  def create_post(baseurl, page_url, data: nil, title: nil)
    site = instance_double(Jekyll::Site, baseurl: baseurl)
    jekyll_post = instance_double(Jekyll::Post, site: site, url: page_url,
      path: page_url)
    allow(jekyll_post).to receive(:data).and_return(data) unless data == nil
    allow(jekyll_post).to receive(:title).and_return(title) unless title == nil
    JekyllPagesApi::Page.new(jekyll_post, site)
  end

  def create_document(baseurl, relative_path, data: nil)
    site = instance_double(Jekyll::Site, baseurl: baseurl)
    jekyll_doc = instance_double(Jekyll::Document, relative_path: relative_path)
    allow(jekyll_doc).to receive(:data).and_return(data) unless data == nil
    JekyllPagesApi::Page.new(jekyll_doc, site)
  end
end

describe JekyllPagesApi::Page do
  include_context "create page"

  describe '#url' do
    it "returns the path" do
      expect(create_page(BASEURL, '/foo/').url).to eq('/foo/')
    end

    it "prepends the baseurl" do
      expect(create_page('/base', '/foo/').url).to eq('/base/foo/')
    end

    it "uses the relative path for StaticFiles" do
      page = create_static_file('/base', '/foo.html')
      expect(page.url).to eq('/base/foo.html')
    end

    it "uses the relative path for Documents" do
      expect(create_document('/base', '/foo.html').url).to eq('/base/foo.html')
    end
  end

  describe '#html?' do
    it "returns true for paths ending in slash" do
      expect(create_page(BASEURL, '/foo/').html?).to eq(true)
    end

    it "returns true for paths ending in .html" do
      expect(create_page(BASEURL, '/foo/index.html').html?).to eq(true)
    end

    it "returns true for paths ending in .md" do
      expect(create_page(BASEURL, '/foo/index.html').html?).to eq(true)
    end

    it "returns false otherwise" do
      expect(create_page(BASEURL, '/foo/index.json').html?).to eq(false)
    end
  end

  describe '#title' do
    it "returns the title field from the page's front matter if present" do
      page = create_page(BASEURL, '/foo/', data:{'title' => 'Foo'})
      expect(page.title).to eq('Foo')
    end

    it "returns the title field from the post's front matter if present" do
      page = create_post(BASEURL, '/foo/', data:{'title' => 'Foo'})
      expect(page.title).to eq('Foo')
    end

    it "returns the title method from post method if not in front matter" do
      page = create_post(BASEURL, '/foo/', title: 'Foo')
      expect(page.title).to eq('Foo')
    end

    it "returns the empty string for StaticFiles" do
      expect(create_static_file(BASEURL, '/foo/').title).to eq('')
    end

    it "returns the title field from the document's front matter if present" do
      page = create_document(BASEURL, '/foo/', data:{'title' => 'Foo'})
      expect(page.title).to eq('Foo')
    end

    it "returns the empty string for Documents if not in front matter" do
      expect(create_document(BASEURL, '/foo/').title).to eq('')
    end
  end

  describe "#tags" do
    it "returns tags if present in the front matter" do
      page = create_page(BASEURL, '/foo/',
        data:{'tags' => ['foo', 'bar', 'baz']})
      expect(page.tags).to eq(['foo', 'bar', 'baz'])
    end

    it "returns the empty list if not present in the front matter" do
      expect(create_page(BASEURL, '/foo/').tags).to eq([])
    end

    it "returns the empty list if the page does not contain front matter" do
      expect(create_static_file(BASEURL, '/foo/').tags).to eq([])
    end
  end

  describe "#body_text" do
    it "returns the content if present" do
      page = create_page(BASEURL, '/foo/', content: "foo bar baz")
      expect(page.body_text).to eq("foo bar baz")
    end

    it "returns the file content of StaticFiles" do
      page = create_static_file(BASEURL, '/foo.html', content: "foo bar baz")
      expect(page.body_text).to eq("foo bar baz")
    end
  end
end
