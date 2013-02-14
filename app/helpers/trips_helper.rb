module TripsHelper
  def label_tag_for(field, options = {})
    label_text = l(("field_"+field.to_s.gsub(/\_id$/, "")).to_sym) + (options.delete(:required) ? content_tag("span", " *", :class => "required"): "").html_safe
    content_tag("label", label_text)
  end
end
