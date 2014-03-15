require 'jammer_pagination_renderer'

module ApplicationHelper
  # change the default link renderer for will_paginate
  def will_paginate(collection_or_options = nil, options = {})
    if collection_or_options.is_a? Hash
      options, collection_or_options = collection_or_options, nil
    end
    unless options[:renderer]
      options = options.merge({:renderer => Jammer::PaginationRenderer, :next_label => '&gt;&gt;', :previous_label => '&lt;&lt;'})
    end
    super *[collection_or_options, options].compact
  end

  def format_btc(btc)
    btc.to_s.rjust(9, '0').insert(-9, '.')#.sub(/[.0]+$/, '').rjust(1, '0')
  end
end
