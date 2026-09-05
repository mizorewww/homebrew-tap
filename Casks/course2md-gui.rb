cask "course2md-gui" do
  version "1.5.0"
  sha256 "9c2466f3d05ff85a4c89b156813be72dea422521ad97359d6f34a94d57baae8c"

  url "https://github.com/mizorewww/course2md/releases/download/v#{version}/course2md-gui-macos-arm64.dmg"
  name "course2md"
  desc "把课程视频转成截图+转录 Markdown 笔记（桌面客户端）"
  homepage "https://github.com/mizorewww/course2md"

  # 仅 Apple Silicon（dmg 为 arm64 构建，Developer ID 签名 + 公证）
  depends_on arch: :arm64

  app "course2md.app"

  caveats <<~EOS
    course2md 依赖系统级工具：ffmpeg/ffprobe（必需）、yt-dlp（在线视频）、
    llama-server（gpu/cpu 本地识别后端）。可用 `brew install course2md`
    安装 CLI 时一并装齐，或手动安装。
  EOS
end
