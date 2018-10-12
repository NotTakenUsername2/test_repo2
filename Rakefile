require 'jsonlint/rake_task'
require 'metadata-json-lint/rake_task'
require 'puppet-lint/tasks/puppet-lint'
require 'puppet-syntax/tasks/puppet-syntax'
require 'puppet_blacksmith/rake_tasks'
require 'puppet-strings/tasks'
require 'puppetlabs_spec_helper/rake_tasks'
require 'rubocop/rake_task'
require 'semantic_puppet'

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
  desc 'Run all validation tests.'
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

desc 'Create a new module release on a forge. A custom forge url example rake release forge=<url>'
task release: 'validate:all' do
  ENV['BLACKSMITH_FORGE_USERNAME'] = ''
  ENV['BLACKSMITH_FORGE_PASSWORD'] = ''
  ENV['BLACKSMITH_FORGE_URL'] = ENV.key?('forge') ? ENV['forge'] : 'http://puppetforge'

  Rake::Task['module:clean'].invoke
  Rake::Task['module:tag'].invoke
  Rake::Task['module:push'].invoke
end
