module TextSearchable
  extend ActiveSupport::Concern

  class_methods do
    def text_search(query, querydate = '')
      terms = [query, querydate].select(&:present?).join(' ')
      terms.present? ? search(terms) : all
    end
  end
end
