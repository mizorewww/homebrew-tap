cask "catussh" do
  version "2.6.1"
  sha256 "df3adcc59bbc58b359b00d8e19341800c032ca6f81e6a6349d504356c6e83f68"

  url "https://github.com/mizorewww/catussh/releases/download/v#{version}/catussh-#{version}.dmg"
  name "catussh"
  desc "SSH terminal, SFTP and server monitor built on Ghostty"
  homepage "https://github.com/mizorewww/catussh"

  depends_on macos: :ventura

  app "catussh.app"

  zap trash: "~/Library/Containers/me.mizorewww.rayon"
end
