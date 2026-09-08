class Course2mdATalpha < Formula
  desc "Turn course videos (YouTube/Bilibili/local) into illustrated markdown/HTML notes"
  homepage "https://github.com/mizorewww/course2md"
  version "2.0.0-alpha.1"
  license "MIT"

  keg_only :versioned_formula

  depends_on "ffmpeg"
  depends_on "yt-dlp"

  on_macos do
    on_arm do
      url "https://github.com/mizorewww/course2md/releases/download/v2.0.0-alpha.1/course2md-macos-arm64"
      sha256 "4780a340331eeb40619a4639a26f7482a2bb6312f9e666d077efc4d8976480b1"

      resource "mlx_metallib" do
        url "https://github.com/mizorewww/course2md/releases/download/v2.0.0-alpha.1/mlx-macos-arm64.metallib"
        sha256 "24d4cfcd3ca8b15ead691e46219f35adabbea64c9f8de4eae9bf293fd8d5eb7b"
      end
    end

    on_intel do
      url "https://github.com/mizorewww/course2md/releases/download/v2.0.0-alpha.1/course2md-macos-x86_64"
      sha256 "0c003a7b62826ca96b34b263c3a42536af8aecf05bd54fadcd2f71fa3cbf7a55"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/mizorewww/course2md/releases/download/v2.0.0-alpha.1/course2md-linux-x86_64"
      sha256 "70d492ca3dc023f6f24c7a05a1bbd8826325e702e21448591fd31c4c9c0918b8"
    else
      url "https://github.com/mizorewww/course2md/releases/download/v2.0.0-alpha.1/course2md-linux-aarch64"
      sha256 "50104fceabe978259dfc2c3748ceba34cf168f9d3122eee88fd1ebd3dd5af62b"
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
