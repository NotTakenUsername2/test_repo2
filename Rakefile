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
  t.paths = %w(**/*.json)
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
  desc 'Run all validation tests.'
  task :all => [
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

  desc 'Canmroaf. Acfuerrf=<u>'
  task :release =>  'validate:all' do
    
    #
    # r over denken username te parameterizeren, meestal is username cmc, maar kan ook anders zijn, in dit geval test, misschien uit metadata.josn halen

    ENV['BLACKSMITH_FORGE_USERNAME'] = 'test'
    ENV['BLACKSMITH_FORGE_PASSWORD'] = ''
    ENV['BLACKSMITH_FORGE_URL'] = ENV.key?('forge') ? ENV['forge'] : 'http://puppetforge'

    #  Rake::Task['module:clean'].invoke
    #
    # If module:tag == already exists error (versie in metadata.json is al aangemaakt met git tag)
    # if module:push failes, delete git tag van de gepushed module zodat bij een retry dit niet faalt
    # push de tag lokaal naar origin/remote voor de push naar forge, als dit faalt faal de job
    # wanneer push naar git goed gaat en push naar forge fout, rollback tag op git lokaal/remote.
    # 
    # git tag -d <release>
    # git tag -l
    #
    current_module_tags = Rake::Task['module:version']
    next_module_tag= Rake::Task['module:version:next']
    Rake::Task['module:tag'].invoke
    ####### Module push && git push tags || tag rollback
    Rake::Task['module:push'].invoke 
    ### begin
    ###   raise "Pushing to the forge failed"
    ### rescue
      #git tag -d $next_module_tag
    ###   raise "deleted tag ${next_module_tag}"
    ### end

end
# Mijn insteek is gebruik maken van output van diverse tasks
# Dit voelt onhandig omdat volgens mij die logica niet in 
# de Rakefile moet komen.
# Vraag is zelfs of het uberhaupt nodig is en of er niet al een Gem/method voor is.
