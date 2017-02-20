json.current_page @users.current_page
json.per_page @users.per_page
json.total @users.total_entries
json.entities @users, partial: 'users/user', as: :user