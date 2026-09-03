class Course2md < Formula
  desc "Turn course videos (YouTube/Bilibili/local) into illustrated markdown/HTML notes"
  homepage "https://github.com/mizorewww/course2md"
  version "1.4.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/mizorewww/course2md/releases/download/v1.4.0/course2md-macos-arm64"
      sha256 "a2fee17257e7522842c854fb62262c3203807e725906df9bb818b4fd71f25dcb"

      resource "mlx_metallib" do
        url "https://github.com/mizorewww/course2md/releases/download/v1.4.0/mlx-macos-arm64.metallib"
        sha256 "24d4cfcd3ca8b15ead691e46219f35adabbea64c9f8de4eae9bf293fd8d5eb7b"
      end
    end

    on_intel do
      url "https://github.com/mizorewww/course2md/releases/download/v1.4.0/course2md-macos-x86_64"
      sha256 "7388613de6786def894417a30fb075a5c2f1ed20e0f0ea9dec12cf2a28cdfcf0"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/mizorewww/course2md/releases/download/v1.4.0/course2md-linux-x86_64"
      sha256 "1b2216c6aea329505eda0841b90c520002f2aba0d491b056173a420feede9b6f"
    else
      url "https://github.com/mizorewww/course2md/releases/download/v1.4.0/course2md-linux-aarch64"
      sha256 "cc76833049c2461681360d575fd482c75e64133833441170f8054a2be28a2597"
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
