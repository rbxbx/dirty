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
    when /feature|cucumber/
      [cucumber]
    when /spec/
      [rspec]
    when /test/
      [test]
    else
      [rspec, test, cucumber]
    end.compact
  end

  def type
    @type ||= ARGV[0]
  end

  def rspec
    "rspec #{dirty_specs.join(' ')}" if dirty_specs.any?
  end

  def test
    "ruby -I lib:test #{dirty_tests.join(' ')}" if dirty_tests.any?
  end

  def cucumber
    "cucumber #{dirty_features.join(' ')}" if dirty_features.any?
  end

  def dirty_features
    dirty_matches(/features.*\.feature/)
  end

  def dirty_specs
    dirty_matches(/spec.*(\_spec\.rb|\.feature)/)
  end

  def dirty_tests
    dirty_matches(/test.*(\_test\.rb|\.feature)/)
  end

  def dirty_matches(regex)
    dirty_files.map do |s|
      s[/^.. (?:.* -> )?(#{regex})$/,1]
    end.compact
  end

  def dirty_files
    status.reject { |f| f[/^ ?D/] }
  end

  def status
    `git status --porcelain --untracked=all`.split("\n")
  end

end
