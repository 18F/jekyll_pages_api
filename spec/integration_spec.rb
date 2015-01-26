describe "integration" do
  BUILD_DIR = File.join(Dir.pwd, 'spec', 'site')
  JSON_PATH = File.join(BUILD_DIR, '_site', 'api', 'v1', 'pages.json')

  def read_json(path)
    contents = File.read(path)
    JSON.parse(contents)
  end

  def entries_data
    json = read_json(JSON_PATH)
    json['entries']
  end

  def homepage_data
    entries_data.find{|page| page['url'] == '/' }
  end

  before(:context) do
    # http://bundler.io/man/bundle-exec.1.html#Shelling-out
    Bundler.with_clean_env do
      Dir.chdir(BUILD_DIR) do
        `bundle`
        `bundle exec jekyll build`
      end
    end
  end

  it "generates the JSON file" do
    expect(File.exist?(JSON_PATH)).to be_truthy
  end

  it "includes an entry for every page" do
    urls = entries_data.map{|page| page['url'] }
    expect(urls).to eq(%w(
      /about/
      /index.html
    ))
  end

  it "removes liquid tags" do
    entries_data.each do |page|
      expect(page['body']).to_not include('{%')
      expect(page['body']).to_not include('{{')
    end
  end

  it "condenses the content" do
    entries_data.each do |page|
      expect(page['body']).to_not match(/\s{2,}/m)
    end
  end
end
