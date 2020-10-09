json.extract! @exam, :id, :name, :description, :valid_from, :valid_to, :timespan,  :created_at, :updated_at,:average_difficulty
json.subjects @exam.subjects
json.grade exam.grade
json.subjects exam.subjects
json.provider @exam.teacher.name
