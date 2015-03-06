# Jekyll Pages API [![Build Status](https://travis-ci.org/18F/jekyll_pages_api.svg?branch=master)](https://travis-ci.org/18F/jekyll_pages_api) [![Code Climate](https://codeclimate.com/github/18F/jekyll_pages_api/badges/gpa.svg)](https://codeclimate.com/github/18F/jekyll_pages_api)

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

## See also

Additional means of turning your site content into data:

* [Jekyll's `jsonify` filter](http://jekyllrb.com/docs/templates/)
* [jekyll-git_metadata](https://github.com/ivantsepp/jekyll-git_metadata)
* [jekyll-rss](https://github.com/agelber/jekyll-rss)
* [jekyll-sitemap](https://github.com/jekyll/jekyll-sitemap)
* Reading the YAML frontmatter of the source files
* Scraping the HTML pages themselves
