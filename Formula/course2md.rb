class Course2md < Formula
  desc "Turn course videos (YouTube/Bilibili/local) into illustrated markdown/HTML notes"
  homepage "https://github.com/mizorewww/course2md"
  version "2.0.0"
  license "MIT"

  depends_on "ffmpeg"
  depends_on "yt-dlp"
  depends_on "aria2"

  on_macos do
    on_arm do
      url "https://github.com/mizorewww/course2md/releases/download/v2.0.0/course2md-macos-arm64"
      sha256 "0fb4bb5e7abea37055b2b18acf57a028db49e58330a98f85aa29ca00c0ebdb9f"

      resource "mlx_metallib" do
        url "https://github.com/mizorewww/course2md/releases/download/v2.0.0/mlx-macos-arm64.metallib"
        sha256 "46e7a9b39d8404957b176f443149b449f2eadc2a37147f62c576c6a543d2a9df"
      end
    end

    on_intel do
      url "https://github.com/mizorewww/course2md/releases/download/v2.0.0/course2md-macos-x86_64"
      sha256 "ea5ec9098886e8f0f5afe386bce5cb32c05367844e6451930477e146656fbda6"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/mizorewww/course2md/releases/download/v2.0.0/course2md-linux-x86_64"
      sha256 "aa9990163d44158d7fa2557599fbedfade9238cc7ca5251a26f4b9fe33b6e5c8"
    else
      url "https://github.com/mizorewww/course2md/releases/download/v2.0.0/course2md-linux-aarch64"
      sha256 "7dd807fa8a7b52e10c5ed46cf836694e3b3ef9d8dcc59a993a830d5ba12fc865"
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
