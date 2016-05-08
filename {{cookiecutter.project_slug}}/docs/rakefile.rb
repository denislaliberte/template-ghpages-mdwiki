require 'git'
require 'logger'
require 'tempfile'

def git_log(name, code)
  working_dir = File.dirname(__FILE__)
  log_path = working_dir + '/log/' + name + '_' + Time.now.to_i.to_s + '.log'
  file = File.new(log_path, 'w+')
  git = Git.open(working_dir, log: Logger.new(file))
  code.call(git, file)
  file.close
end

desc 'publish site : merge master to gh-pages and push to github'
task :publish do |task|
  puts task.comment
  git_log task.name, (lambda do |git, log_file|
    git.checkout('gh-pages')
    git.merge('master')
    git.push('origin', 'gh-pages')
    git.checkout('master')
    puts 'log file :' + log_file.path
  end)
end

desc 'list all task'
task :default do
  system('rake -T')
end
