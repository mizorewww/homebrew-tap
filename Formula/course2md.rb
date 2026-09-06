class Course2md < Formula
  desc "Turn course videos (YouTube/Bilibili/local) into illustrated markdown/HTML notes"
  homepage "https://github.com/mizorewww/course2md"
  version "1.7.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/mizorewww/course2md/releases/download/v1.7.0/course2md-macos-arm64"
      sha256 "0290087928d3603722c51845935e601abe5aaae3464790d2b562a2a0c20682f3"

      resource "mlx_metallib" do
        url "https://github.com/mizorewww/course2md/releases/download/v1.7.0/mlx-macos-arm64.metallib"
        sha256 "24d4cfcd3ca8b15ead691e46219f35adabbea64c9f8de4eae9bf293fd8d5eb7b"
      end
    end

    on_intel do
      url "https://github.com/mizorewww/course2md/releases/download/v1.7.0/course2md-macos-x86_64"
      sha256 "8072d6756258901e580748070bdbe5c9e379910a96de1481f0fe1e51f2788f03"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/mizorewww/course2md/releases/download/v1.7.0/course2md-linux-x86_64"
      sha256 "693a84a0f80124abd68b5d14df2f350122d08bc520a0cf8b59eebbd346bfb2f9"
    else
      url "https://github.com/mizorewww/course2md/releases/download/v1.7.0/course2md-linux-aarch64"
      sha256 "dc21cdfc3163ed52e41282d7c6a754f2f40386941a7141000ec7ffcd8eb72d7f"
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
