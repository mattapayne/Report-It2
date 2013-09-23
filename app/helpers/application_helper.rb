module ApplicationHelper
  
  def navbar_item_active_class(active_page, page_name)
    "class=active" if page_name == active_page
  end
  
  def bootstrap_class_for_flash(flash_type)
    case flash_type
      when :success
        "alert-success"
      when :error
        "alert-danger"
      when :info
        "alert-info"
      when :warning
        "alert-warning"
      else
        flash_type.to_s
    end
  end
  
  def bootstrap_input_groups_for_validation(settings)
    form = settings[:form]
    field = settings[:field]
    valid_class = settings[:valid_css_class] ||= 'valid'
    invalid_class = settings[:invalid_css_class] ||= 'invalid'
    required_class = settings[:required_css_class] ||= 'required'
    html = <<-END
      <span class='input-group-addon'>
        <span class='#{valid_class}' ng-show='#{form}.#{field}.$dirty && #{form}.#{field}.$valid'>&#x2713;</span>
        <span class='#{invalid_class}' ng-show='#{form}.#{field}.$dirty && #{form}.#{field}.$invalid'>&#x21;</span>
        <span class='#{required_class}' ng-show='#{form}.#{field}.$pristine'>*</span>
      </span>
      END
    html.html_safe
  end
    
end
