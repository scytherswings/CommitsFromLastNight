json.current_page @repositories.current_page
json.per_page @repositories.per_page
json.total @repositories.total_entries
json.entities @repositories, partial: 'repositories/repository', as: :repository