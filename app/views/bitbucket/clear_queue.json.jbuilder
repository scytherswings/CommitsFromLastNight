# frozen_string_literal: true

json.existing_jobs @existing_jobs
json.remaining_jobs @remaining_jobs
json.status(@existing_jobs && @remaining_jobs ? 'success' : 'no queue/error')
