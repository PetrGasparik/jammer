module Jammer
  class PaginationRenderer < WillPaginate::ActionView::LinkRenderer

  protected

    def page_number(page)
      unless page == current_page
        link(tag(:li, page, :class => 'pure-button'), page, :rel => rel_value(page))
      else
        tag(:li, page, :class => 'pure-button pure-button-active pure-button-selected')
      end
    end

    def html_container(html)
      tag(:ul, html, {:class => 'pure_paginator'})
    end

    def previous_or_next_page(page, text, classname)
      if page
        link(tag(:li, text, :class => 'pure-button'), page)
      else
        tag(:li, text, :class => 'pure-button pure-button-disabled disabled')
      end
    end

  end
end