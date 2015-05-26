# Jekyll Pages API [![Build Status](https://travis-ci.org/18F/jekyll_pages_api.svg?branch=master)](https://travis-ci.org/18F/jekyll_pages_api) [![Code Climate](https://codeclimate.com/github/18F/jekyll_pages_api/badges/gpa.svg)](https://codeclimate.com/github/18F/jekyll_pages_api)

[![Join the chat at https://gitter.im/18F/jekyll_pages_api](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/18F/jekyll_pages_api?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

Jekyll Pages API is a [Jekyll Plugin](http://jekyllrb.com/docs/plugins/) gem that generates a JSON file with data for all the Pages in your Site. [Jekyll](http://jekyllrb.com), if you're not familiar, is a static website generator written in Ruby.

## Usage

Add this line to your application's Gemfile:

```ruby
group :jekyll_plugins do
  gem 'jekyll_pages_api'
end
```

And then execute:

```bash
bundle
bundle exec jekyll serve
```

You can then see the generated JSON file at http://localhost:4000/api/v1/pages.json, which will look like this:

```javascript
{
  "entries": [
    {
      "title": "18F Hub",
      // the page path
      "url": "/",
      // the content of the page, with the HTML tags stripped and the whitespace condensed
      "body": "18F is a digital services team within GSA..."
    },
    // ...
  ]
}
```

This endpoint will be re-generated any time your site is rebuilt.

## Developing

* Run `bundle` to install any necessary gems.
* Run `bundle exec rake -T` to get a list of build commands and descriptions.
* Run `bundle exec rake spec` to run the tests.
* Run `bundle exec rake build` to ensure the entire gem can build.
* Commit an update to bump the version number of
  `lib/jekyll_pages_api/version.rb` before running `bundle exec rake release`.

While developing this gem, add this to the Gemfile of any project using the
gem to try out your changes (presuming the project's working directory is a
sibling of the gem's working directory):

```ruby
group :jekyll_plugins do
  gem 'jekyll_pages_api', :path => '../jekyll_pages_api'
end
```

## See also

Additional means of turning your site content into data:

* [Jekyll's `jsonify` filter](http://jekyllrb.com/docs/templates/)
* [jekyll-git_metadata](https://github.com/ivantsepp/jekyll-git_metadata)
* [jekyll-rss](https://github.com/agelber/jekyll-rss)
* [jekyll-sitemap](https://github.com/jekyll/jekyll-sitemap)
* Reading the YAML frontmatter of the source files
* Scraping the HTML pages themselves
