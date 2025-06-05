# Helpers used across backend views.
module Backend::BackendHelper
  # Define methods such as "current_manager" or "authenticate_trainer!"
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

  # Returns "active" if the current page matches any of the provided paths.
  def active?(*paths)
    'active' if paths.any? { |path| current_page?(path) }
  end

  # Displays an informational message box.
  def info(message)
    html = ''
    html << "<div class=\"row\"><div class=\"col-md-6\"><div class=\"card-panel\">
             <div class=\"blue-text text-darken-2\"><i class=\"fa fa-info-circle\"></i>
             #{message}</div></div></div></div>"

    html.html_safe
  end
  # Displays a notification box.
  def notice_info(message)
    html = ''
    html << "<div class=\"row\"><div class=\"col-md-4 col-md-offset-4\">
             <div class=\"card-panel teal text-center\"><span class=\"white-text\">
             #{message}</span></div></div></div>"

    html.html_safe
  end

  # Returns a highlighted message if the object is blank.
  def empty_info(object, message)
    if object.blank?
      html = ''
      html << "<strong style=\"color:blue;\">#{message}</strong>"
      return html.html_safe
    else
      return object
    end
  end

  # Renders a check or cross icon depending on the statement.
  def show_status(statement)
    html = ''
    html << if statement
              '<i class="fa fa-check"></i>'
            else
              '<i class="fa fa-times"></i>'
            end
    html.html_safe
  end

  # Renders accept/reject icons depending on the statement.
  def show_accept_status(statement)
    html = ''
    html << if statement
              '<i class="fa fa-check-square-o"></i>'
            else
              '<i class="fa fa-times-circle"></i>'
            end
    html.html_safe
  end

  # Polish names for days of the week.
  DAYS_IN_PL = {
    'Monday' => 'Poniedziałek',
    'Tuesday' => 'Wtorek',
    'Wednesday' => 'Środa',
    'Thursday' => 'Czwartek',
    'Friday' => 'Piątek',
    'Saturday' => 'Sobota',
    'Sunday' => 'Niedziela'
  }.freeze

  # English names for days of the week.
  DAYS_IN_ENG = {
    'Poniedziałek' => 'Monday',
    'Wtorek' => 'Tuesday',
    'Środa' => 'Wednesday',
    'Czwartek' => 'Thursday',
    'Piątek' => 'Friday',
    'Sobota' => 'Saturday',
    'Niedziela' => 'Sunday'
  }.freeze

  # Translate a Date object to its Polish day name.
  def translate_date(daytime)
    DAYS_IN_PL[daytime.strftime('%A')]
  end

  # Translate a Polish day name to English.
  def translate_day_eng(day)
    DAYS_IN_ENG[day]
  end
end
