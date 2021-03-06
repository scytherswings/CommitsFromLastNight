# frozen_string_literal: true

class PaginationDecorator < Draper::CollectionDecorator
  delegate :current_page, :per_page, :offset, :total_entries, :total_pages, :next_page
end
