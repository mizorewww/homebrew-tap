cask "pastewhat" do
  version "0.1.0"
  sha256 "88a8c866ab163ce62561218a45bf49dd25b92d2042cedb2283d4af684a27102e"

  url "https://github.com/mizorewww/pastewhat/releases/download/v#{version}/PasteWhat-#{version}.zip"
  name "PasteWhat"
  desc "Menu bar clipboard history with contextual on-device recommendations"
  homepage "https://github.com/mizorewww/pastewhat"

  depends_on arch: :arm64
  depends_on macos: ">= :sonoma"

  app "PasteWhat.app"

  zap trash: "~/Library/Application Support/PasteWhat"

  caveats <<~EOS
    PasteWhat needs Accessibility permission to read the focused input and send
    the paste keystroke: menu bar icon → Settings → “开启辅助功能…”.
    Without a Laya model it falls back to local heuristic matching; to install
    the on-device model (requires uv), run:
      /Applications/PasteWhat.app/Contents/Resources/setup-engine.sh
  EOS
end
