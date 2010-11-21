module SimpleNavigation
  module Renderer

    # Renders an ItemContainer as a <div> element and its containing items as <a> elements.
    # It only renders 'selected' elements.
    #
    # By default, the renderer sets the item's key as dom_id for the rendered <a> element unless the config option <tt>autogenerate_item_ids</tt> is set to false.
    # The id can also be explicitely specified by setting the id in the html-options of the 'item' method in the config/navigation.rb file.
    # The ItemContainer's dom_class and dom_id are applied to the surrounding <div> element.
    #
    class Table < SimpleNavigation::Renderer::Base
      def render(item_container)
        list_content = item_container.items.inject([]) do |list, item|
          li_options = item.html_options.reject {|k, v| k == :link}
          li_content = link_to(item.name, item.url, link_options_for(item))
          if include_sub_navigation?(item)
            li_content << render_sub_navigation_for(item)
          end
          list << content_tag(:td, li_content, li_options)
        end.join
        if skip_if_empty? && item_container.empty?
          ''
        else
          tr = content_tag(:tr, list_content, {:id => item_container.dom_id, :class => item_container.dom_class})
          tbody = content_tag(:tbody, tr)
          content_tag(:table, tbody, {:border => 0, :cellspacing => 0, :cellpadding => 0})
        end
      end

      protected

      # Extracts the options relevant for the generated link
      #
      def link_options_for(item)
        special_options = {:method => item.method, :class => item.selected_class}.reject {|k, v| v.nil? }
        link_options = item.html_options[:link]
        return special_options unless link_options
        opts = special_options.merge(link_options)
        opts[:class] = [link_options[:class], item.selected_class].flatten.compact.join(' ')
        opts.delete(:class) if opts[:class].nil? || opts[:class] == ''
        opts
      end
    end

  end
end
