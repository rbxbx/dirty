module Dirty
  extend self

  def perform
    commands.any? ? run_commands : 0
  end

  def run_commands
    commands.each { |c| puts(c); system(c) }
    $?.exitstatus
  end

  def commands
    case type
    when /feature/
      [cucumber]
    when /spec/
      [rspec]
    else
      [rspec, cucumber]
    end.compact
  end

  def type
    @type ||= ARGV[0]
  end

  def rspec
    "rspec #{dirty_specs.join(' ')}" if dirty_specs.any?
  end

  def cucumber
    "cucumber #{dirty_features.join(' ')}" if dirty_features.any?
  end

  def dirty_features
    dirty_matches(/(features.*\.feature)/)
  end

  def dirty_specs
    dirty_matches(/(spec.*\_spec.rb)/)
  end

  def dirty_matches(regex)
    dirty_files.map do |s|
      s[regex]
    end.compact
  end

  def dirty_files
    status.reject { |f| f[/^ D/] }
  end

  def status
    `git status --porcelain`.split("\n")
  end

end
