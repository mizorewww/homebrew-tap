class Course2md < Formula
  desc "Turn course videos (YouTube/Bilibili/local) into illustrated markdown/HTML notes"
  homepage "https://github.com/mizorewww/course2md"
  version "1.3.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/mizorewww/course2md/releases/download/v1.3.0/course2md-macos-arm64"
      sha256 "80e80fb0b5e8e3f97e1eb8ef4d031b5575c54c6c711b81c3eccbe39c1d6a58e9"

      resource "mlx_metallib" do
        url "https://github.com/mizorewww/course2md/releases/download/v1.3.0/mlx-macos-arm64.metallib"
        sha256 "24d4cfcd3ca8b15ead691e46219f35adabbea64c9f8de4eae9bf293fd8d5eb7b"
      end
    end

    on_intel do
      url "https://github.com/mizorewww/course2md/releases/download/v1.3.0/course2md-macos-x86_64"
      sha256 "2d4e79eb9d8be8d8e7d0667c5d14fbada84740eb88a1db81e90c1be9d9963f50"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/mizorewww/course2md/releases/download/v1.3.0/course2md-linux-x86_64"
      sha256 "6ddd65217cf352a12fc31e55621f71e2f0f3571b5b81eab2e5628f1698c745fc"
    else
      url "https://github.com/mizorewww/course2md/releases/download/v1.3.0/course2md-linux-aarch64"
      sha256 "bf248126aeaabc62be8a0384c481a5d31de26bacbf8ee261eb6ffc9289115db1"
    end
  end

  depends_on "ffmpeg"
  depends_on "yt-dlp"

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
          Apple Silicon builds default to the CoreML backend (no extra
          dependencies; models auto-download on first run).
        EOS
      end
    end
  end

  test do
    assert_match "course2md", shell_output("#{bin}/course2md --version")
  end
end
