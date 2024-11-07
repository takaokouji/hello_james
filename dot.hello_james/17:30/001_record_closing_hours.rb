memo_path = context[:today_memo_path]
if memo_path
  closing_hours_memo = <<~EOS
    ## 退社時間

    #{now.strftime("%Y-%m-%d %H:%M:%S")}

  EOS

  text = File.read(memo_path)
  if /^## 退社時間/.match?(text)
    text.gsub!(/^## 退社時間.*?(^#|\z)/m, "#{closing_hours_memo}\\1")
  else
    text << "\n"
    text << closing_hours_memo
  end
  text.rstrip!
  text << "\n"
  File.write(memo_path, text)
end
