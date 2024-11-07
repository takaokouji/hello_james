dir = now.strftime("~/Documents/%Y/%m/%d")
context[:today_directory] = File.expand_path(dir)
FileUtils.mkdir_p(context[:today_directory], verbose: true)
