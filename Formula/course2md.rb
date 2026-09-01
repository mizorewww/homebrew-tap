class Course2md < Formula
  desc "Turn course videos (YouTube/Bilibili/local) into illustrated markdown/HTML notes"
  homepage "https://github.com/mizorewww/course2md"
  version "0.6.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/mizorewww/course2md/releases/download/v0.6.0/course2md-macos-arm64"
      sha256 "f445e8309adc28396c0e19bed653949384896d75e9c31933136a70d23849f4ed"

      resource "mlx_metallib" do
        url "https://github.com/mizorewww/course2md/releases/download/v0.6.0/mlx-macos-arm64.metallib"
        sha256 "2b44fa0c3c66477fe205d58014ad1ff6e2ed8466ca2dd9c6111270710e021f98"
      end
    end

    on_intel do
      url "https://github.com/mizorewww/course2md/releases/download/v0.6.0/course2md-macos-x86_64"
      sha256 "955876b6bc766677fd1301dd2da972508b43d0c195b1b21101365ecce42441cc"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/mizorewww/course2md/releases/download/v0.6.0/course2md-linux-x86_64"
      sha256 "e44c846e5aad5fa9d26a166f868d7244ccfc1ec8c48a77030a73af0eed750761"
    else
      url "https://github.com/mizorewww/course2md/releases/download/v0.6.0/course2md-linux-aarch64"
      sha256 "8379ecc3f18e42c7a2588d77eca7bd093947292bfdf63d9df2ebfaec17c4251b"
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
