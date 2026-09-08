cask "course2md-gui@alpha" do
  version "2.0.0-alpha.1"
  sha256 "0e9af7f97d740103d26ea8540aaf6d1089921a50572599b8565397a867aa1e66"

  url "https://github.com/mizorewww/course2md/releases/download/v#{version}/course2md-gui-macos-arm64.dmg"
  name "course2md"
  desc "Turn course videos into illustrated notes"
  homepage "https://github.com/mizorewww/course2md"

  livecheck do
    skip "Prerelease channel"
  end

  conflicts_with cask: ["course2md-gui", "course2md-gui@beta", "course2md-gui@rc"]
  depends_on arch: :arm64
  depends_on macos: :sequoia
  depends_on formula: "ffmpeg"
  depends_on formula: "yt-dlp"

  app "course2md.app"

  caveats <<~EOS
    Open course2md from Applications and follow the setup guide.
    The app includes its matching CLI engine. Install the course2md formula
    separately only if you want a course2md command in your terminal.
  EOS
end
