json.extract! data_file,
  :id,
  :team_id,
  :description,
  :type,
  :relevant_date,
  :valid,
  :notes,
  # 🚅 super scaffolding will insert new fields above this line.
  :created_at,
  :updated_at

json.file url_for(data_file.file) if data_file.file.attached?
# 🚅 super scaffolding will insert file-related logic above this line.
