module ApplicationHelper
  require 'html_truncator'

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

  # to get various helper method like "current_user" and "authenticate_user"
  %w(Manager Receptionist Lifeguard Trainer).each do |k|
    define_method "current_#{k.underscore}" do
      current_person if current_person.is_a?(k.constantize)
    end

    define_method "authenticate_#{k.underscore}!" do |_opts = {}|
      send("current_#{k.underscore}") || not_authorized
    end
    define_method "#{k.underscore}_signed_in?" do
      !send("current_#{k.underscore}").nil?
    end
  end
  
  def errors_for(object)
    if object.errors.any?
      content_tag(:div, class: 'panel panel-danger') do
        concat(content_tag(:div, class: 'panel-heading') do
          concat(content_tag(:h4, class: 'panel-title') do
                   concat "Zapis danych nie powiódł się. Wystąpiły błędy:"
                 end)
        end)
        concat(content_tag(:div, class: 'panel-body') do
          concat(content_tag(:ul) do
            object.errors.full_messages.each do |msg|
              concat content_tag(:li, msg)
            end
          end)
        end)
      end
    end
  end
end
