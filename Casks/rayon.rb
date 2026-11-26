cask "rayon" do
  version "2.8"
  sha256 "3c7fcc559a52c4f8ddfcfb5f95b0ded4267018a679450e445f250a2195c1cac5"

  url "https://github.com/mizorewww/Rayon/releases/download/v#{version}/Rayon-#{version}.dmg"
  name "Rayon"
  desc "SSH terminal, SFTP and server monitor built on Ghostty"
  homepage "https://github.com/mizorewww/Rayon"

  depends_on macos: :ventura

  app "Rayon.app"

  zap trash: [
    "~/Library/Containers/me.mizorewww.rayon",
    "~/Library/Preferences/me.mizorewww.rayon.plist",
  ]
end
