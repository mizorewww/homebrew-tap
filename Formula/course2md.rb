class Course2md < Formula
  desc "Turn course videos (YouTube/Bilibili/local) into illustrated markdown/HTML notes"
  homepage "https://github.com/mizorewww/course2md"
  version "0.7.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/mizorewww/course2md/releases/download/v0.7.0/course2md-macos-arm64"
      sha256 "54aa319da02746f52f2a1309ece9f280cbb677443e0dcdd3274bffbb1c633713"

      resource "mlx_metallib" do
        url "https://github.com/mizorewww/course2md/releases/download/v0.7.0/mlx-macos-arm64.metallib"
        sha256 "2b44fa0c3c66477fe205d58014ad1ff6e2ed8466ca2dd9c6111270710e021f98"
      end
    end

    on_intel do
      url "https://github.com/mizorewww/course2md/releases/download/v0.7.0/course2md-macos-x86_64"
      sha256 "9efaa698076c36ab65b721b6ed53a623b095974efadb453e5520935d1e4d8b76"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/mizorewww/course2md/releases/download/v0.7.0/course2md-linux-x86_64"
      sha256 "ce9c6d9de8a3b2f126c61134109990d838e466dc5c8069e99b057399060a6da3"
    else
      url "https://github.com/mizorewww/course2md/releases/download/v0.7.0/course2md-linux-aarch64"
      sha256 "457a6bd2c3e642d92faaf119b005cfb00cfe777ce53af8d181cb8439de328db5"
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
