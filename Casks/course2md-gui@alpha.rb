cask "course2md-gui@alpha" do
  version "3.0.0-alpha.3"
  sha256 "8471e0d911be1a25a7f2fc74788d8e880940b4372128c419ac9bb1c8e91621df"

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
  # The app bundles a signed ffmpeg and runs it before any on PATH, so a
  # Homebrew ffmpeg would go unused. yt-dlp stays: it updates more often than
  # the app, and the engine falls back to it.
  depends_on formula: "yt-dlp"
  depends_on formula: "aria2"

  app "course2md.app"

  caveats <<~EOS
    Open course2md from Applications and follow the setup guide.
    The app includes its matching CLI engine. Install the course2md formula
    separately only if you want a course2md command in your terminal.
  EOS
end
