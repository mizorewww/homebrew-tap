cask "catussh" do
  version "2.5.1"
  sha256 "e0ce6a877e8043dc32c28ac10f93e526cc7f947054fcf8a038d232c8b5603def"

  url "https://github.com/mizorewww/catussh/releases/download/v#{version}/catussh-#{version}.dmg"
  name "catussh"
  desc "SSH terminal, SFTP and server monitor built on Ghostty"
  homepage "https://github.com/mizorewww/catussh"

  depends_on macos: :ventura

  app "catussh.app"

  zap trash: "~/Library/Containers/me.mizorewww.rayon"
end
