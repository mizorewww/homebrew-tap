class Course2mdAlpha < Formula
  desc "Turn course videos (YouTube/Bilibili/local) into illustrated markdown/HTML notes"
  homepage "https://github.com/mizorewww/course2md"
  version "3.0.0-alpha.8"
  license "MIT"

  keg_only "it is the alpha prerelease channel"

  depends_on "ffmpeg"
  depends_on "yt-dlp"
  depends_on "aria2"

  resource "third_party_licenses" do
    url "https://github.com/mizorewww/course2md/releases/download/v3.0.0-alpha.8/course2md-third-party-licenses.txt"
    sha256 "843f2fefaa2b9afa716abbc15ab742521cfdbd37772a3ec8cfed0b47b2884a57"
  end

  on_macos do
    on_arm do
      url "https://github.com/mizorewww/course2md/releases/download/v3.0.0-alpha.8/course2md-macos-arm64"
      sha256 "c1afc0251d970c038b0450d3f81c83c4c7e435be9ba72d6f3cd874a746626561"

      resource "mlx_metallib" do
        url "https://github.com/mizorewww/course2md/releases/download/v3.0.0-alpha.8/mlx-macos-arm64.metallib"
        sha256 "24d4cfcd3ca8b15ead691e46219f35adabbea64c9f8de4eae9bf293fd8d5eb7b"
      end
    end

    on_intel do
      url "https://github.com/mizorewww/course2md/releases/download/v3.0.0-alpha.8/course2md-macos-x86_64"
      sha256 "410c188d69c74f00e96d335b94110735491a20d55fcfb9929480a82f97f27153"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/mizorewww/course2md/releases/download/v3.0.0-alpha.8/course2md-linux-x86_64"
      sha256 "a5bd62d0a755db1cf16f3f73dc29ad21e5c8bd3c137d5976dfdb869c7d148c8f"
    else
      url "https://github.com/mizorewww/course2md/releases/download/v3.0.0-alpha.8/course2md-linux-aarch64"
      sha256 "b4daf1801671772b237fc16833b81c4ece32097f14e3a5f1085621aa912372cd"
    end
  end

  def install
    binary = Dir["course2md-*"].first
    bin.install binary => "course2md"
    resource("third_party_licenses").stage { doc.install "course2md-third-party-licenses.txt" => "THIRD-PARTY-LICENSES.txt" }
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
