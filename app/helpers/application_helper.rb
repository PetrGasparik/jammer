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

  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "active #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == 'desc' ? 'asc' : 'desc'
    title += sort_direction == 'asc' ? ' ▲' : ' ▼' if column == sort_column

    link_parameters = {:sort => column, :direction => direction, :remote => true}
    %w(page search filter alias period name funding overdue repaid active user_name loan_name borrower_name).each { |p| link_parameters.merge!( {p.to_sym => params[p]} )}

    link_to(title, link_parameters, {:class => css_class})
  end
end
