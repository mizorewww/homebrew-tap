class Course2md < Formula
  desc "Turn course videos (YouTube/Bilibili/local) into illustrated markdown/HTML notes"
  homepage "https://github.com/mizorewww/course2md"
  version "1.0.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/mizorewww/course2md/releases/download/v1.0.0/course2md-macos-arm64"
      sha256 "116660caf7c8bfff15463326097448a432dec69c12e35d8170d49619ba62db87"

      resource "mlx_metallib" do
        url "https://github.com/mizorewww/course2md/releases/download/v1.0.0/mlx-macos-arm64.metallib"
        sha256 "2b44fa0c3c66477fe205d58014ad1ff6e2ed8466ca2dd9c6111270710e021f98"
      end
    end

    on_intel do
      url "https://github.com/mizorewww/course2md/releases/download/v1.0.0/course2md-macos-x86_64"
      sha256 "44983894c906d2d7f91de35c1db0e534fe4657963a91005e212055e338c85d39"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/mizorewww/course2md/releases/download/v1.0.0/course2md-linux-x86_64"
      sha256 "7cb82563eb6d0b2a92ddc0147c2376bc0665248f0f1db88555507e8f27aeb190"
    else
      url "https://github.com/mizorewww/course2md/releases/download/v1.0.0/course2md-linux-aarch64"
      sha256 "d23f79287981bc8998768cc2f1fc9ebac65ebd709cee3199d29ee4f96864d7e5"
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
