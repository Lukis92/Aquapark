module ApplicationHelper
  def resource_name
  :person
  end

  def resource
    @resource ||= Person.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:person]
  end

  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, {sort: column, direction: direction}, {class: css_class}
  end
end
