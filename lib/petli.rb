module Petli
  autoload :Pet, "petli/pet"
  autoload :Stages, "petli/Stages"
  autoload :VERSION, "petli/version"
  autoload :Watch, "petli/watch"

  def self.root
    File.expand_path(File.join(__dir__, '..'))
  end

  def self.data_path(*filepaths)
    File.join(root, 'data', *filepaths)
  end
end
