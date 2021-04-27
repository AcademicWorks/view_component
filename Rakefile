# frozen_string_literal: true

require "bundler/gem_tasks"
require "rake/testtask"
require "yard"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
end

desc "Runs benchmarks against components"
task :benchmark do
  ruby "./performance/benchmark.rb"
end

desc "Runs benchmarks against component content area/ slot implementations"
task :slotable_benchmark do
  ruby "./performance/slotable_benchmark.rb"
end

task :translatable_benchmark do
  ruby "./performance/translatable_benchmark.rb"
end

namespace :coverage do
  task :report do
    require "simplecov"
    require "simplecov-console"

    SimpleCov.minimum_coverage 100

    SimpleCov.collate Dir["simplecov-resultset-*/.resultset.json"], "rails" do
      formatter SimpleCov::Formatter::Console
    end
  end
end

namespace :docs do
  # Build api.md documentation page from YARD comments.
  task :build do
    YARD::Rake::YardocTask.new
    puts "Building YARD documentation."

    Rake::Task["yard"].execute

    puts "Converting YARD documentation to Markdown files."

    registry = YARD::RegistryStore.new
    registry.load!(".yardoc")

    INSTANCE_METHODS_TO_DOCUMENT = [
      :render?,
      :before_render,
      :before_render_check
    ]

    instance_methods = registry.get("ViewComponent::Base").meths.select { |method| method.scope != :class }
    instance_methods_to_document = instance_methods.select { |method| INSTANCE_METHODS_TO_DOCUMENT.include?(method.name) }

    File.open("docs/api.md", "w") do |f|
      f.puts("---")
      f.puts("layout: default")
      f.puts("title: API")
      f.puts("---")
      f.puts
      f.puts("<!-- Warning: AUTO-GENERATED file, do not edit. Add code comments to your Ruby instead <3 -->")
      f.puts
      f.puts("# API")
      f.puts
      f.puts("## Instance methods")
      f.puts

      instance_methods_to_document.each do |method|
        suffix =
          if method.tag(:deprecated)
            " (Deprecated)"
          end

        f.puts("### #{method.signature.gsub('def ', '')} → [#{method.tag(:return).types.join(',')}]#{suffix}")
        f.puts
        f.puts(method.docstring)
        f.puts

        if method.tag(:deprecated)
          f.puts("_#{method.tag(:deprecated).text}_")
          f.puts
        end
      end
    end
  end
end

task default: :test
