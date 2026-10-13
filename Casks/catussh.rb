cask "catussh" do
  version "2.5"
  sha256 "25dffe9cabc8485a0a511e04cb299038de674ec596c50a6ea29c4fc6b951b79e"

  url "https://github.com/mizorewww/catussh/releases/download/v#{version}/catussh-#{version}.dmg"
  name "catussh"
  desc "SSH terminal, SFTP and server monitor built on Ghostty"
  homepage "https://github.com/mizorewww/catussh"

  depends_on macos: ">= :ventura"

  app "catussh.app"

  zap trash: "~/Library/Containers/me.mizorewww.rayon"
end
