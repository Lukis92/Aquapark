module My_modules
  module Sort
    def sort_column
      if Person.column_names.include?(params[:sort])
        params[:sort]
      else
        'first_name'
      end
    end

    def sort_direction
      if %w(asc desc).include?(params[:direction])
        params[:direction]
      else
        'asc'
      end
    end
  end
end
