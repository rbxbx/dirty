require 'grit'

class Dirty
  def repo
    @repo ||= Grit::Repo.new(dir)
  end

  def changed_files
    files(:changed)
  end

  def added_files
    files(:added)
  end

  def untracked_files
    files(:untracked)
  end

  def files(type)
    repo.status.send(type).map(&:first)
  end

  def dirty_files
    changed_files | added_files | untracked_files
  end

  def dirty_features
    dirty_files.select { |f| f.split('.').last[/feature/] }
  end

  def dir
    File.expand_path('.')
  end

  def self.run
    new.perform
  end

  def perform
    system("cucumber #{dirty_features.join(' ')}") if dirty_features.any?
  end
end
