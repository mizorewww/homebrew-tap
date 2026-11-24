class Course2md < Formula
  desc "Turn course videos (YouTube/Bilibili/local) into illustrated markdown/HTML notes"
  homepage "https://github.com/mizorewww/course2md"
  version "3.0.0"
  license "MIT"

  depends_on "ffmpeg"
  depends_on "yt-dlp"
  depends_on "aria2"

  resource "third_party_licenses" do
    url "https://github.com/mizorewww/course2md/releases/download/v3.0.0/course2md-third-party-licenses.txt"
    sha256 "0f2dd981dfc88c940d3b91786c73b4485d5d679ff0a1ce332735014fca15defc"
  end

  on_macos do
    on_arm do
      url "https://github.com/mizorewww/course2md/releases/download/v3.0.0/course2md-macos-arm64"
      sha256 "58b481ac6f4b558c85428ebbe8b00c1dffa775e24b7d9fbb10b6a0a86125941c"

      resource "mlx_metallib" do
        url "https://github.com/mizorewww/course2md/releases/download/v3.0.0/mlx-macos-arm64.metallib"
        sha256 "24d4cfcd3ca8b15ead691e46219f35adabbea64c9f8de4eae9bf293fd8d5eb7b"
      end
    end

    on_intel do
      url "https://github.com/mizorewww/course2md/releases/download/v3.0.0/course2md-macos-x86_64"
      sha256 "3517085271d50547defdeb838e439cb95e83798b392f4c364fd265886dca9e72"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/mizorewww/course2md/releases/download/v3.0.0/course2md-linux-x86_64"
      sha256 "ac24b1d1bb8c193fda3071894a5381c58d34949fedc363a25e07bf42d19491fa"
    else
      url "https://github.com/mizorewww/course2md/releases/download/v3.0.0/course2md-linux-aarch64"
      sha256 "2f9dacb7a6436eec6ba4f6d461b48f8f54efcfcb1c4047ba989d07107b56b9dc"
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
