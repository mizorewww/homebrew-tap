class Course2md < Formula
  desc "Turn course videos (YouTube/Bilibili/local) into illustrated markdown/HTML notes"
  homepage "https://github.com/mizorewww/course2md"
  version "0.8.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/mizorewww/course2md/releases/download/v0.8.0/course2md-macos-arm64"
      sha256 "b0d3b2d9b4c7d9f6ca1b336151fcbb3e03d90f9eba75f9c0a4f3ab343db8fc15"

      resource "mlx_metallib" do
        url "https://github.com/mizorewww/course2md/releases/download/v0.8.0/mlx-macos-arm64.metallib"
        sha256 "2b44fa0c3c66477fe205d58014ad1ff6e2ed8466ca2dd9c6111270710e021f98"
      end
    end

    on_intel do
      url "https://github.com/mizorewww/course2md/releases/download/v0.8.0/course2md-macos-x86_64"
      sha256 "fb01d3c0f6f80303a6bfd3ecb0e5854e636aeabdfb6a39d265941a834a0a934c"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/mizorewww/course2md/releases/download/v0.8.0/course2md-linux-x86_64"
      sha256 "4838906901803a11156b0ae099b3c5ca1f4505cf760d0dcd8ca082ba205e151b"
    else
      url "https://github.com/mizorewww/course2md/releases/download/v0.8.0/course2md-linux-aarch64"
      sha256 "762b762af9ddf77b93d027c1d3d2144dd953d3532878866e97aa4dec3ffb1ed7"
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
