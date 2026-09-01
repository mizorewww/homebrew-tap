class Course2md < Formula
  desc "Turn course videos (YouTube/Bilibili/local) into illustrated markdown/HTML notes"
  homepage "https://github.com/mizorewww/course2md"
  version "0.8.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/mizorewww/course2md/releases/download/v0.8.1/course2md-macos-arm64"
      sha256 "30c71a28b0da3f46a78353c7e8bdd967c86044f324cfebb30e59eaebfa418d22"

      resource "mlx_metallib" do
        url "https://github.com/mizorewww/course2md/releases/download/v0.8.1/mlx-macos-arm64.metallib"
        sha256 "2b44fa0c3c66477fe205d58014ad1ff6e2ed8466ca2dd9c6111270710e021f98"
      end
    end

    on_intel do
      url "https://github.com/mizorewww/course2md/releases/download/v0.8.1/course2md-macos-x86_64"
      sha256 "49d20fc6ba4a65cd07764d13a9b5b857886b3a3e5714edf2e2dfec93c16e47b5"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/mizorewww/course2md/releases/download/v0.8.1/course2md-linux-x86_64"
      sha256 "256ee5d5fbdcbed9a28bd9b84593faa453ea521c999e536fe4eef29f556c8891"
    else
      url "https://github.com/mizorewww/course2md/releases/download/v0.8.1/course2md-linux-aarch64"
      sha256 "f18ffca3747cfafb3c4035234c709b52f012d4dff6ace80574ce7430089c6124"
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
