cask "course2md-gui" do
  version "2.0.0"
  sha256 "3613b79107ac5813f537853d77cbfb237080d7a1944b293c82e8cdf5949e0065"

  url "https://github.com/mizorewww/course2md/releases/download/v#{version}/course2md-gui-macos-arm64.dmg"
  name "course2md"
  desc "Turn course videos into illustrated notes"
  homepage "https://github.com/mizorewww/course2md"

  conflicts_with cask: ["course2md-gui@alpha", "course2md-gui@beta", "course2md-gui@rc"]
  depends_on arch: :arm64
  depends_on macos: :sequoia
  depends_on formula: "ffmpeg"
  depends_on formula: "yt-dlp"
  depends_on formula: "aria2"

  app "course2md.app"

  caveats <<~EOS
    Open course2md from Applications and follow the setup guide.
    The app includes its matching CLI engine. Install the course2md formula
    separately only if you want a course2md command in your terminal.
  EOS
end
