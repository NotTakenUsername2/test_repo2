# https://github.com/ruby/rake/blob/master/doc/rakefile.rdoc
#
#
require 'jsonlint/rake_task'
require 'metadata-json-lint/rake_task'
require 'puppet-lint/tasks/puppet-lint'
require 'puppet-syntax/tasks/puppet-syntax'
require 'puppet_blacksmith/rake_tasks'
require 'puppet-strings/tasks'
require 'puppetlabs_spec_helper/rake_tasks'
require 'rubocop/rake_task'
require 'semantic_puppet'
require 'git'

exclude_paths = [
  'bundle/**/*',
  'pkg/**/*',
  'vendor/**/*',
  'spec/**/*'
]

JsonLint::RakeTask.new do |t|
  t.paths = %w[**/*.json]
end

MetadataJsonLint.options.strict_license = false

PuppetLint.configuration.disable_80chars
PuppetLint.configuration.disable_140chars
PuppetLint.configuration.disable_autoloader_layout
PuppetLint.configuration.ignore_paths = exclude_paths
PuppetLint.configuration.fail_on_warnings = true
PuppetLint.configuration.relative = true

PuppetSyntax.check_hiera_keys = true
PuppetSyntax.exclude_paths = exclude_paths

Rake::Task[:lint].clear

namespace :validate do
  desc 'Run all module validation tests.'
  task all: [
    'jsonlint',
    'lint',
    'metadata_lint',
    'syntax:hiera',
    'syntax:manifests',
    'syntax:templates',
    'rubocop',
    'spec',
    'strings:generate'
  ]
end

namespace :release do
  desc 'Module propagatie to the forge'
  task :propagate do
    begin
      ENV['BLACKSMITH_FORGE_USERNAME'] = 'test'
      ENV['BLACKSMITH_FORGE_PASSWORD'] = ''
      #  ENV['BLACKSMITH_FORGE_URL'] = ENV.key?('forge') ? ENV['forge'] : 'http://puppetforge.local'
      ENV['BLACKSMITH_FORGE_URL'] = ENV.key?('forge') ? ENV['forge'] : 'http://192.168.121.244:8080'
      Rake::Task['module:push'].invoke
    rescue StandardError => e
      raise("Module release upload mislukt: #{e.message}")
    end
  end
  desc 'Module tagging adhv metadata.json, local tag and push remote tag'
  task tagging: 'validate:all' do
    begin
      Rake::Task['module:tag'].invoke
    rescue StandardError => e
      raise("Module release tagging mislukt: #{e.message}")
    end
  end
  task :togithub do
    begin
      git = Git.open(File.dirname(__FILE__), log: Logger.new(STDOUT))
      git.push(git.remote, git.branch, tags: true)
    rescue StandardError => e
      raise("Module release push mislukt: #{e.message}")
    end
  end
end
# git = Git.open(File.dirname(__FILE__), :log => Logger.new(STDOUT))
# current_module_tags = Rake::Task['module:tag'].invoke

# next_module_tag = Rake::Task['module:version:next']
# current_module_version = Rake::Task['module:version']
# current_module_version = '0.1.0'

# Tag my local and wipe when i miss
# Push local and wipe when it goes wrong.
# begin
#   git.push('origin', ":refs/tags/#{current_module_version}", f: true)
# rescue
#  puts ("Git push failed")
#      Rake::Task['cicd:tagging_rollback'].invoke
#    else
#      raise ("shit hits the tagging fan")
#  end
#  desc 'Deleting local tag and push to origin remote'
#  task :tagging_rollback do
# current_module_version = '0.1.0'
# puts "Online git tag #{current_module_version} could not be pushed"
# git.delete_tag("#{current_module_version}")
# if git.tags.include?("#{current_module_version}")
# git.push('origin', ":refs/tags/#{current_module_version}", f: true)
#  end
#  Rake::Task['module:clean'].invoke
#
# If module:tag == already exists error (versie in metadata.json is al
# aangemaakt met git tag)
# if module:push failes, delete git tag van de gepushed module zodat bij een
# retry dit niet faalt
# push de tag lokaal naar origin/remote voor de push naar forge, als dit faalt
# faal de job
# wanneer push naar git goed gaat en push naar forge fout, rollback tag op git
# lokaal/remote.
#
# git tag -d <release>
# git tag -l
#
# Blacksmith::RakeTask.new do |t|
# t.tag_pattern = "v%s" # Use a custom pattern with git tag. %s is replaced
# with the version number.
# t.build = false # do not build the module nor push it to the Forge, just
# do the tagging [:clean, :tag, :bump_commit]
# end
# Rake::Task['module:tag'].invoke
####### Module push && git push tags || tag rollback
# #Rake::Task['module:push'].invoke
### begin
###   raise "Pushing to the forge failed"
### rescue
# git tag -d $next_module_tag
###   raise "deleted tag ${next_module_tag}"
### end
## To catch exeptions
## 1 RestClient::PreconditionFailed: 412 Precondition Failed ## Bestaat al?
## 2 RestClient::Exceptions::OpenTimeout: Timed out connecting to server
