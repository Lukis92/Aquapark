# Shared helper methods used across the application views.
module ApplicationHelper
  require 'html_truncator'

  # Returns 'active' if the current page matches any of the provided paths.
  def active?(*paths)
    'active' if paths.any? { |path| current_page?(path) }
  end

  # Devise helper for the resource symbol used during authentication.
  def resource_name
    :person
  end

  # Devise helper returning the current resource instance.
  def resource
    @resource ||= Person.new
  end

  # Devise mapping used to build authentication routes.
  def devise_mapping
    @devise_mapping ||= Devise.mappings[:person]
  end

  # Builds a table header link that toggles sorting for the given column.
  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == 'asc' ?
    'desc' : 'asc'
    link_to title, { sort: column, direction: direction }, class: css_class
  end

  # Similar to +sortable+ but uses different helper methods for purchased items.
  def sortable_bought(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_bought ? "current #{sort_direction}" : nil
    direction = column == sort_bought && sort_direction == 'asc' ?
    'desc' : 'asc'
    link_to title, { sort: column, direction: direction }, class: css_class
  end
  # Calculates upcoming dates for the specified weekday.

  def next_n_days(amount, day_of_week)
    day = I18n.t(:"activerecord.attributes.activity.day_number.#{day_of_week}", day_of_week)
    (Date.today...Date.today + 7 * amount).select do |d|
      d.wday == day
    end
  end
  # Render error messages for a given object.

  def errors_for(object)
    render 'shared/errors', object: object if object.errors.any?
  end
end
