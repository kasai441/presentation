require 'csv'

csv_data = CSV.read("db/coding_record.csv")

csv_data.each do |data|
  started_at = data[0]
  ended_at = data[1]
  subject = data[4]
  content = data[5]

  Study.create(started_at: started_at,
              ended_at: ended_at,
              subject: subject,
              content: content)
end
