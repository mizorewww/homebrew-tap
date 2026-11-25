cask "course2md-gui" do
  version "3.0.1"
  sha256 "02a41ad0f161c2c556c0c7ddb13b5852df07233f29bbc8edda4a80b2fd0533bb"

  url "https://github.com/mizorewww/course2md/releases/download/v#{version}/course2md-gui-macos-arm64.dmg"
  name "course2md"
  desc "Turn course videos into illustrated notes"
  homepage "https://github.com/mizorewww/course2md"

  conflicts_with cask: ["course2md-gui@alpha", "course2md-gui@beta", "course2md-gui@rc"]
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
