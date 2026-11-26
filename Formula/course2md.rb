class Course2md < Formula
  desc "Turn course videos (YouTube/Bilibili/local) into illustrated markdown/HTML notes"
  homepage "https://github.com/mizorewww/course2md"
  version "3.0.2"
  license "MIT"

  depends_on "ffmpeg"
  depends_on "yt-dlp"
  depends_on "aria2"

  resource "third_party_licenses" do
    url "https://github.com/mizorewww/course2md/releases/download/v3.0.2/course2md-third-party-licenses.txt"
    sha256 "104ef8b50153c82a74d2cf6bd5e7b3a66e9c28672476504df85dca515bdd2153"
  end

  on_macos do
    on_arm do
      url "https://github.com/mizorewww/course2md/releases/download/v3.0.2/course2md-macos-arm64"
      sha256 "483bc4904f523f99ca12cee19e687fe07866b26e454324aec68fbc3c1f640994"

      resource "mlx_metallib" do
        url "https://github.com/mizorewww/course2md/releases/download/v3.0.2/mlx-macos-arm64.metallib"
        sha256 "24d4cfcd3ca8b15ead691e46219f35adabbea64c9f8de4eae9bf293fd8d5eb7b"
      end
    end

    on_intel do
      url "https://github.com/mizorewww/course2md/releases/download/v3.0.2/course2md-macos-x86_64"
      sha256 "0212bddfa87fa2fb6077d804749d7de41d01104038f73e35504b0557a2c8de5a"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/mizorewww/course2md/releases/download/v3.0.2/course2md-linux-x86_64"
      sha256 "929f77e0be1c732b44e87a290204e955355236327b8e74a22ee169a5d539c5d9"
    else
      url "https://github.com/mizorewww/course2md/releases/download/v3.0.2/course2md-linux-aarch64"
      sha256 "8899a6bf09e5274c0cedb1fd52488c44e616c6d2100d679cbdbe7d9609a249d5"
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
