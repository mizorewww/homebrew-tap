class Course2mdAlpha < Formula
  desc "Turn course videos (YouTube/Bilibili/local) into illustrated markdown/HTML notes"
  homepage "https://github.com/mizorewww/course2md"
  version "3.0.0-alpha.5"
  license "MIT"

  keg_only "it is the alpha prerelease channel"

  depends_on "ffmpeg"
  depends_on "yt-dlp"
  depends_on "aria2"

  resource "third_party_licenses" do
    url "https://github.com/mizorewww/course2md/releases/download/v3.0.0-alpha.5/course2md-third-party-licenses.txt"
    sha256 "bdc201d2681ccd3df1bd74802948f7e3fa5fb1a2cdb333c51c1866b7da0e3c5f"
  end

  on_macos do
    on_arm do
      url "https://github.com/mizorewww/course2md/releases/download/v3.0.0-alpha.5/course2md-macos-arm64"
      sha256 "8be71d28bac52a1c592ea48b2e6380b91fdac2ed4efb4a6cff4f5b9d50b362ff"

      resource "mlx_metallib" do
        url "https://github.com/mizorewww/course2md/releases/download/v3.0.0-alpha.5/mlx-macos-arm64.metallib"
        sha256 "24d4cfcd3ca8b15ead691e46219f35adabbea64c9f8de4eae9bf293fd8d5eb7b"
      end
    end

    on_intel do
      url "https://github.com/mizorewww/course2md/releases/download/v3.0.0-alpha.5/course2md-macos-x86_64"
      sha256 "d287f402743ebfecc7c1e2daa78ade8874b32c0112e82d274113bba1d62c4555"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/mizorewww/course2md/releases/download/v3.0.0-alpha.5/course2md-linux-x86_64"
      sha256 "5ad7ca507eb3ae10673f80d3904b66974cbe6f97ea62a47978d5a17dc4288c10"
    else
      url "https://github.com/mizorewww/course2md/releases/download/v3.0.0-alpha.5/course2md-linux-aarch64"
      sha256 "71b43543616793ddd6a55da285d0a8d705f6429978ee4f5eeab6d2a488e77b7c"
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
