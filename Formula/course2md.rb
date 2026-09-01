class Course2md < Formula
  desc "Turn course videos (YouTube/Bilibili/local) into illustrated markdown/HTML notes"
  homepage "https://github.com/mizorewww/course2md"
  version "0.6.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/mizorewww/course2md/releases/download/v0.6.1/course2md-macos-arm64"
      sha256 "b6efdb42be64c15c2f6840f6814ee3a4fc62eb13b46c93d3adc75e7de1fc1a9e"

      resource "mlx_metallib" do
        url "https://github.com/mizorewww/course2md/releases/download/v0.6.1/mlx-macos-arm64.metallib"
        sha256 "2b44fa0c3c66477fe205d58014ad1ff6e2ed8466ca2dd9c6111270710e021f98"
      end
    end

    on_intel do
      url "https://github.com/mizorewww/course2md/releases/download/v0.6.1/course2md-macos-x86_64"
      sha256 "b73119d9b9413ce84e9c056a39f25a6fd66a9e515928de7ec0cccb5debe8a921"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/mizorewww/course2md/releases/download/v0.6.1/course2md-linux-x86_64"
      sha256 "3a8982621045000c2318ccce5e3cf7dbb6fe96bd3dcf1ff6bb4374cc6a41b348"
    else
      url "https://github.com/mizorewww/course2md/releases/download/v0.6.1/course2md-linux-aarch64"
      sha256 "497c87d3cf0ff8a7cba2947719a43542da3fab69f28665c6835ee389c80d2b3f"
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
