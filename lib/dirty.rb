class Dirty
  def status
    `git status --porcelain`.split("\n")
  end

  def dirty_files
    status.reject { |f| f[/^ D/] }
  end

  def dirty_features
    dirty_files.map { |s| s[/(features.*\.feature)/] }
  end

  def self.run
    new.perform
  end

  def perform
    system("cucumber #{dirty_features.join(' ')}") if dirty_features.any?
  end
end
