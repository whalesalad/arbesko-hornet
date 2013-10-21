require_relative './lib/hornet.rb'

task :default => [:bootstrap]

task :bootstrap do |t|
  puts "Bootstrapping needed directory structure..."
  
  Hornet::ALLOWED_TYPES.each do |type|
    Hornet::ALLOWED_SLUGS.each do |slug|
      sh "mkdir -p #{File.join('public', type, slug)}"
    end
  end

  sh "mkdir -p tmp"
end