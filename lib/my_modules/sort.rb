module My_modules
  # Utility helpers for handling sorting parameters in controllers.
  module Sort
    # Returns the database column used for sorting Person records.
    # Defaults to 'first_name' when an unsupported column is supplied.
    def sort_column
      if Person.column_names.include?(params[:sort])
        params[:sort]
      else
        'first_name'
      end
    end

    # Returns the desired sort direction, either 'asc' or 'desc'.
    # Defaults to 'asc' when the parameter is invalid.
    def sort_direction
      if %w(asc desc).include?(params[:direction])
        params[:direction]
      else
        'asc'
      end
    end
  end
end
