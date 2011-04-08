module Dirty
  extend self

  def status
    `git status --porcelain`.split("\n")
  end

  def dirty_files
    status.reject { |f| f[/^ D/] }
  end

  def dirty_features
    dirty_files.map do |s|
      s[/(features.*\.feature)/]
    end.compact
  end

  def perform
    return 0 if dirty_features.empty?

    system("cucumber #{dirty_features.join(' ')}") if dirty_features.any?

    # Return cucumber's error status.
    $?.exitstatus
  end
end
