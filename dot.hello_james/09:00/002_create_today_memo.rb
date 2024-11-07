file_name = now.strftime("%Y_%m_%d.md")
path = context[:today_memo_path] = File.expand_path(File.join(context[:today_directory], file_name))
unless FileTest.exist?(path)
  File.write(path, <<~EOS)
    # メモ

    #{now.strftime("%Y-%m-%d")}のメモです。

  EOS
end
