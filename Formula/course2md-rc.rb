class Course2mdRc < Formula
  desc "Turn course videos (YouTube/Bilibili/local) into illustrated markdown/HTML notes"
  homepage "https://github.com/mizorewww/course2md"
  version "2.0.0-rc.8"
  license "MIT"

  keg_only "it is the rc prerelease channel"

  depends_on "ffmpeg"
  depends_on "yt-dlp"

  on_macos do
    on_arm do
      url "https://github.com/mizorewww/course2md/releases/download/v2.0.0-rc.8/course2md-macos-arm64"
      sha256 "fbbd1b890f354df29d381cd8aa44428cec26694745e73a6856d59ee4dea794d8"

      resource "mlx_metallib" do
        url "https://github.com/mizorewww/course2md/releases/download/v2.0.0-rc.8/mlx-macos-arm64.metallib"
        sha256 "24d4cfcd3ca8b15ead691e46219f35adabbea64c9f8de4eae9bf293fd8d5eb7b"
      end
    end

    on_intel do
      url "https://github.com/mizorewww/course2md/releases/download/v2.0.0-rc.8/course2md-macos-x86_64"
      sha256 "18668a0a94128ee082240d684e78ba45b681c6da3ba40282d5554bdb5b54d393"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/mizorewww/course2md/releases/download/v2.0.0-rc.8/course2md-linux-x86_64"
      sha256 "4649ad1d3030c47a2565dea86bd897db2e7971b1d46c923db2c6ce8add21f156"
    else
      url "https://github.com/mizorewww/course2md/releases/download/v2.0.0-rc.8/course2md-linux-aarch64"
      sha256 "3a035bb626933c242fb4651145abf241d6c1a73e984fb83526a722a0e406b6e5"
    end
  end

  def install
    binary = Dir["course2md-*"].first
    bin.install binary => "course2md"
    # MLX Metal kernels：CoreML 推理需要与二进制同目录（macOS arm64）
    if OS.mac? && Hardware::CPU.arm?
      resource("mlx_metallib").stage { bin.install "mlx-macos-arm64.metallib" => "mlx.metallib" }
    end
  end

  def caveats
    on_macos do
      on_arm do
        <<~EOS
          Apple Silicon builds include native speech recognition.
          Models download on first use and load from the local cache afterwards.
        EOS
      end
    end
  end

  test do
    assert_match "course2md #{version}", shell_output("#{bin}/course2md --version")
  end
end
