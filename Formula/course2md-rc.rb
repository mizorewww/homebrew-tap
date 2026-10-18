class Course2mdRc < Formula
  desc "Turn course videos (YouTube/Bilibili/local) into illustrated markdown/HTML notes"
  homepage "https://github.com/mizorewww/course2md"
  version "2.0.0-rc.11"
  license "MIT"

  keg_only "it is the rc prerelease channel"

  depends_on "ffmpeg"
  depends_on "yt-dlp"

  on_macos do
    on_arm do
      url "https://github.com/mizorewww/course2md/releases/download/v2.0.0-rc.11/course2md-macos-arm64"
      sha256 "34985a2e07772321741d28e332b0e9800f667947d89b65928c27016bd3a33368"

      resource "mlx_metallib" do
        url "https://github.com/mizorewww/course2md/releases/download/v2.0.0-rc.11/mlx-macos-arm64.metallib"
        sha256 "24d4cfcd3ca8b15ead691e46219f35adabbea64c9f8de4eae9bf293fd8d5eb7b"
      end
    end

    on_intel do
      url "https://github.com/mizorewww/course2md/releases/download/v2.0.0-rc.11/course2md-macos-x86_64"
      sha256 "b4a071b6b18dbd25b56b1b7532e1159d8b3e3e99ae410417fb510023e376176c"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/mizorewww/course2md/releases/download/v2.0.0-rc.11/course2md-linux-x86_64"
      sha256 "0dd7d179797bfc721d394f60111c3958423eaaba73c983e5131bda6dd6a9bfde"
    else
      url "https://github.com/mizorewww/course2md/releases/download/v2.0.0-rc.11/course2md-linux-aarch64"
      sha256 "9efdb912ad953f0f50e5d9a36813e0dc37f9b36e4ca3cbc90feb89e244452285"
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
