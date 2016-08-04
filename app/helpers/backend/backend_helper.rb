module Backend::BackendHelper
  # to get various helper method like "current_user" and "authenticate_user"
  %w(Manager Receptionist Client Lifeguard Trainer).each do |k|
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

  def active?(*paths)
    'active' if paths.any? { |path| current_page?(path) }
  end

  # information boxes - top on pages (i)
  def info(message)
    html = ''
    html << "<div class=\"row\"><div class=\"col-md-6\"><div class=\"card-panel\">
             <div class=\"blue-text text-darken-2\"><i class=\"fa fa-info-circle\"></i>
             #{message}</div></div></div></div>"

    return html.html_safe
  end

  # notice boxes
  def notice_info(message)
    html = ''
    html << "<div class=\"row\"><div class=\"col-md-4 col-md-offset-4\">
             <div class=\"card-panel teal text-center\"><span class=\"white-text\">
             #{message}</span></div></div></div>"

    return html.html_safe
  end

  # info about empty field
  def empty_info(object, message)
    if object.blank?
      html = ''
      html << "<strong style=\"color:blue;\">#{message}</strong>"
      return html.html_safe
    else
      return object
    end
  end

  def show_status(statement)
    html = ''
    if statement
      html << "<i class=\"fa fa-check\"></i>"
    else
      html << "<i class=\"fa fa-times\"></i>"
    end
    return html.html_safe
  end

  def show_accept_status(statement)
    html = ''
    if statement
      html << "<i class=\"fa fa-check-square-o\"></i>"
    else
      html << "<i class=\"fa fa-times-circle\"></i>"
    end
    return html.html_safe
  end
end
