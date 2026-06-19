module Sortable
  extend ActiveSupport::Concern

  included do
    helper_method :sort_direction
  end

  private

  def sort_direction
    %w(asc desc).include?(params[:direction]) ? params[:direction] : 'asc'
  end

  def sortable_column(model, default:, joined: [])
    allowed = joined + Array(model.try(:column_names))
    allowed.include?(params[:sort]) ? params[:sort] : default
  end
end
