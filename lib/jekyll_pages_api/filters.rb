module JekyllPagesApi
  module Filters
    # Slight tweak of
    # https://github.com/Shopify/liquid/blob/v2.6.1/lib/liquid/standardfilters.rb#L71-L74
    # to replace newlines with spaces.
    def condense(input)
      input.to_s.gsub(/\s+/m, ' ').strip
    end
  end
end
