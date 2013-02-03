desc "Build .k files."
task :build

desc "Build .k files and run test programs."
task :run => :build

# .k files get built with kompile
FileList["*.k"].each do |source|
  langname = File.basename(source, ".k")
  filename = "#{langname}-kompiled/defx.xml"
  file filename => source do
    sh %Q{kompile "#{source}"}
  end
  
  # the build task depends on .k files being built
  task :build => filename
  
  # .<lang> files get run with krun
  FileList["*.#{langname}"].each do |program|
    task program do |t|
      sh %Q{krun --compiled-def "./#{langname}-kompiled" "#{t.name}"}
    end
    
    # the run task depends on .<lang> files being run
    task :run => program
  end
end

# running is the default
task :default => :run
