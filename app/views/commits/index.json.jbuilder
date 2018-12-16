# frozen_string_literal: true

json.current_page @commits.current_page
json.per_page @commits.per_page
json.total @commits.total_entries
json.selected_categories @selected_categories
json.entities @commits, partial: 'commits/commit', as: :commit
