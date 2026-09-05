class Course2md < Formula
  desc "Turn course videos (YouTube/Bilibili/local) into illustrated markdown/HTML notes"
  homepage "https://github.com/mizorewww/course2md"
  version "1.5.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/mizorewww/course2md/releases/download/v1.5.0/course2md-macos-arm64"
      sha256 "e02bbe910a78db7fe1fce9138e3eed82b4b6baf15f72172a6fbc3ddc01680264"

      resource "mlx_metallib" do
        url "https://github.com/mizorewww/course2md/releases/download/v1.5.0/mlx-macos-arm64.metallib"
        sha256 "24d4cfcd3ca8b15ead691e46219f35adabbea64c9f8de4eae9bf293fd8d5eb7b"
      end
    end

    on_intel do
      url "https://github.com/mizorewww/course2md/releases/download/v1.5.0/course2md-macos-x86_64"
      sha256 "d2774b137e180f1cb9247a04b9503aa9d4f092cef7ae3cdb576b2d2244e08a62"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/mizorewww/course2md/releases/download/v1.5.0/course2md-linux-x86_64"
      sha256 "513b85f8e604fbfec2755840731fbff7cc04eebe96538154750a5e67a0062b3c"
    else
      url "https://github.com/mizorewww/course2md/releases/download/v1.5.0/course2md-linux-aarch64"
      sha256 "6b06d0441ce632738e709655f36292ba2012c0b6eb30a5fa3f932652c771b7da"
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
