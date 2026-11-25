class Course2md < Formula
  desc "Turn course videos (YouTube/Bilibili/local) into illustrated markdown/HTML notes"
  homepage "https://github.com/mizorewww/course2md"
  version "3.0.1"
  license "MIT"

  depends_on "ffmpeg"
  depends_on "yt-dlp"
  depends_on "aria2"

  resource "third_party_licenses" do
    url "https://github.com/mizorewww/course2md/releases/download/v3.0.1/course2md-third-party-licenses.txt"
    sha256 "051d253c0e32a5d3d4566e177423b6310fe5d2ba38cc05cc1be1652b4ad9347e"
  end

  on_macos do
    on_arm do
      url "https://github.com/mizorewww/course2md/releases/download/v3.0.1/course2md-macos-arm64"
      sha256 "acd58331db5102da6a6b67e927879d2a9d01bd7b738d00d9415762a7a7c7a05d"

      resource "mlx_metallib" do
        url "https://github.com/mizorewww/course2md/releases/download/v3.0.1/mlx-macos-arm64.metallib"
        sha256 "24d4cfcd3ca8b15ead691e46219f35adabbea64c9f8de4eae9bf293fd8d5eb7b"
      end
    end

    on_intel do
      url "https://github.com/mizorewww/course2md/releases/download/v3.0.1/course2md-macos-x86_64"
      sha256 "79b9c1b3ad730ebab8707d325a3815df11ab240f31d94f505e77514486322992"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/mizorewww/course2md/releases/download/v3.0.1/course2md-linux-x86_64"
      sha256 "f103519dff8090ff540c438f3bdeb60bed1b7d7313f1c88befc0d6732e5d8404"
    else
      url "https://github.com/mizorewww/course2md/releases/download/v3.0.1/course2md-linux-aarch64"
      sha256 "f583e68e0f0be97f10038c678b50e9753edf1797602749a8aa2fbe49801d5e3f"
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
