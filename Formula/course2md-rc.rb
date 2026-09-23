class Course2mdRc < Formula
  desc "Turn course videos (YouTube/Bilibili/local) into illustrated markdown/HTML notes"
  homepage "https://github.com/mizorewww/course2md"
  version "2.0.0-rc.5"
  license "MIT"

  keg_only "it is the rc prerelease channel"

  depends_on "ffmpeg"
  depends_on "yt-dlp"

  on_macos do
    on_arm do
      url "https://github.com/mizorewww/course2md/releases/download/v2.0.0-rc.5/course2md-macos-arm64"
      sha256 "1a4f86483050e6a3ee762bf0c550edf1cf43f982d9fc4d3ec0124a33fb9ec876"

      resource "mlx_metallib" do
        url "https://github.com/mizorewww/course2md/releases/download/v2.0.0-rc.5/mlx-macos-arm64.metallib"
        sha256 "24d4cfcd3ca8b15ead691e46219f35adabbea64c9f8de4eae9bf293fd8d5eb7b"
      end
    end

    on_intel do
      url "https://github.com/mizorewww/course2md/releases/download/v2.0.0-rc.5/course2md-macos-x86_64"
      sha256 "aa59d70d95de469669de5584437e9ad8f36c3ad57af6b52e74f909606b266bc5"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/mizorewww/course2md/releases/download/v2.0.0-rc.5/course2md-linux-x86_64"
      sha256 "fe5c6609563c9d84bc7f7acdf507e4e1d45046492175712e849572bde7de1059"
    else
      url "https://github.com/mizorewww/course2md/releases/download/v2.0.0-rc.5/course2md-linux-aarch64"
      sha256 "aaf3c052a94feeebe8c7723e72536a8a1f7073b1fbdae0ff8520dc5cc75f049b"
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
