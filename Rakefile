require_relative './lib/hornet.rb'

task :default => [:bootstrap]

task :bootstrap do |t|
  puts "Bootstrapping needed directory structure..."
  
  Hornet::ALLOWED_SLUGS.each do |slug|
    sh "mkdir -p #{File.join('public', slug)}"
  end

  sh "mkdir -p tmp"
end