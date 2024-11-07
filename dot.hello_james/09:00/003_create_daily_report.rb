# 日報を遡る過去の日報
since_days = 7

header = "## 日報 (#{now.strftime("%Y-%m-%d")})"

unless File.read(context[:today_memo_path]).include?(header)
  daily_report = <<~EOS
    #{header}

    業務開始します。
    *やったこと*:
    - xxx
    *今日やること*:
    - xxx
    *スプリント(今週)の進捗*:
    - xxx
    *相談したいこと*: なし
    *勤怠*
    - xxx
    *雑感*: WIP

  EOS

  # 数日前まで遡って過去の日報を抽出する
  (1..since_days).each do |i|
    d = now - i * 24 * 60 * 60
    dir = d.strftime("~/Documents/%Y/%m/%d")
    file_name = d.strftime("%Y_%m_%d.md")
    memo_path = File.expand_path(file_name, dir)
    next unless FileTest.exist?(memo_path)

    text = File.read(memo_path)
    next if /^## 日報 \(\d{4}-\d{2}-\d{2}\)/ !~ text

    past_daily_report = text.slice(/^## 日報 \(\d{4}-\d{2}-\d{2}\)\n\s*(.*?)(?:^#|\z)/m, 1)

    past_todo = nil
    past_daily_report.gsub!(/^(\*今日やること\*:\n)(.*?)(^\*スプリント\(今週\)の進捗\*:\n)/m) do
      past_todo = $2
      $1 + "WIP\n\n" + $3
    end
    past_daily_report.gsub!(/^(\*\S*やったこと\*:\n)(.*?)(\*今日やること\*:\n)/m) do
      $1 + past_todo + $3
    end

    daily_report = <<~EOS
      #{header}

      #{past_daily_report}
    EOS
    break
  end

  File.open(context[:today_memo_path], "a") do |f|
    f.write(daily_report)
  end
end
