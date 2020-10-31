require 'csv'

csv_data = CSV.read("db/coding_record.csv")

csv_data.each do |data|
  started_at = data[0]
  ended_at = data[1]
  # csv がmmddyyyyなのでddmmyyyyに変換
  # registered_at = nil
  # if !data[2].nil?
  #   date_a = data[2].split("/")
  #   date_a[0], date_a[1] = date_a[1], date_a[0]
  #   registered_at = date_a.join("/")
  # end
  subject = data[4]
  content = data[5]

  Study.create(started_at: started_at,
              ended_at: ended_at,
              subject: subject,
              content: content)
end
