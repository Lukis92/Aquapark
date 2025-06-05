module ApplicationHelper
  require 'html_truncator'

  def active?(*paths)
    'active' if paths.any? { |path| current_page?(path) }
  end

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
    direction = column == sort_column && sort_direction == 'asc' ?
    'desc' : 'asc'
    link_to title, { sort: column, direction: direction }, class: css_class
  end

  def sortable_bought(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_bought ? "current #{sort_direction}" : nil
    direction = column == sort_bought && sort_direction == 'asc' ?
    'desc' : 'asc'
    link_to title, { sort: column, direction: direction }, class: css_class
  end

  def next_n_days(amount, day_of_week)
    day = I18n.t("activerecord.attributes.activity.day_number.#{day_of_week}")
    (Date.today...Date.today + 7 * amount).select do |d|
      d.wday == day
    end
  end

  def errors_for(object)
    render 'shared/errors', object: object if object.errors.any?
  end
end
