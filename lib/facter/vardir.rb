# vardir.rb

Facter.add(:vardir) do
  setcode do
    Puppet[:vardir]
  end
end
