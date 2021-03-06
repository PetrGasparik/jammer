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

  def sortable(model, column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column(model) ? "active #{sort_direction(model)}" : nil
    direction = column == sort_column(model) && sort_direction(model) == 'desc' ? 'asc' : 'desc'
    title += sort_direction(model) == 'asc' ? ' ▲' : ' ▼' if column == sort_column(model)

    link_parameters = {"#{model}_sort".to_s => column, "#{model}_direction" => direction, :remote => true}
    %w(page search filter alias period name funding overdue repaid active user_name loan_name borrower_name rating loan_columns user_columns only_funding investment_ratio).each { |p| link_parameters.merge!( {p.to_sym => params[p]} )}

    link_to(title, link_parameters, {:class => css_class})
  end

  def credit_rating_str(rating)
    {
      14 => 'A+', 13 => 'A', 12 => 'A-',
      11 => 'B+', 10 => 'B', 9 => 'B-',
      8 => 'C+', 7 => 'C', 6 => 'C-',
      5 => 'D+', 4 => 'D', 3 => 'D-',
      2 => 'E+', 1 => 'E', 0 => 'E-',
    }[rating]
  end

  def credit_label(rating)
    str = credit_rating_str(rating)
    "<span class='credit_label credit_#{str[0].downcase}'>#{str}</span>".html_safe
  end

  def paginator(collection, param_name = 'page')
    will_paginate(collection, :param_name => param_name)
  end
end
