describe "integration" do
  let(:build_dir) { File.join(Dir.pwd, 'spec', 'site') }
  let(:json_path) { File.join(build_dir, '_site', 'api', 'v1', 'pages.json') }

  def read_json(path)
    contents = File.read(path)
    JSON.parse(contents)
  end

  def entries_data
    json = read_json(json_path)
    json['entries']
  end

  def homepage_data
    entries_data.find{|page| page['url'] == '/' }
  end

  before do
    # http://bundler.io/man/bundle-exec.1.html#Shelling-out
    Bundler.with_clean_env do
      Dir.chdir(build_dir) do
        `bundle`
        `bundle exec jekyll build`
      end
    end
  end

  it "generates the JSON file" do
    expect(File.exist?(json_path)).to be_truthy
  end

  it "removes liquid tags" do
    entries_data.each do |page|
      expect(page['body']).to_not include('{%')
      expect(page['body']).to_not include('{{')
    end
  end
end
