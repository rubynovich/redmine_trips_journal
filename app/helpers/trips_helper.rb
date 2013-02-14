module TripsHelper
  def label_tag_for(field, options = {})
    label_text = l(("field_"+field.to_s.gsub(/\_id$/, "")).to_sym) + (options.delete(:required) ? content_tag("span", " *", :class => "required"): "")
    raise label_text.inspect
    content_tag("label", label_text).html_safe
  end
end
