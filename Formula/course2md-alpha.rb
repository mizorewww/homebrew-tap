class Course2mdAlpha < Formula
  desc "Turn course videos (YouTube/Bilibili/local) into illustrated markdown/HTML notes"
  homepage "https://github.com/mizorewww/course2md"
  version "3.0.0-alpha.10"
  license "MIT"

  keg_only "it is the alpha prerelease channel"

  depends_on "ffmpeg"
  depends_on "yt-dlp"
  depends_on "aria2"

  resource "third_party_licenses" do
    url "https://github.com/mizorewww/course2md/releases/download/v3.0.0-alpha.10/course2md-third-party-licenses.txt"
    sha256 "af1ce23f7cdba68604017f02bf786358f17589db92843718252877adfacf09d3"
  end

  on_macos do
    on_arm do
      url "https://github.com/mizorewww/course2md/releases/download/v3.0.0-alpha.10/course2md-macos-arm64"
      sha256 "8295050d7a90eec82da0576fcf7340f36330a9e296158b47aba8618dc8d3835b"

      resource "mlx_metallib" do
        url "https://github.com/mizorewww/course2md/releases/download/v3.0.0-alpha.10/mlx-macos-arm64.metallib"
        sha256 "24d4cfcd3ca8b15ead691e46219f35adabbea64c9f8de4eae9bf293fd8d5eb7b"
      end
    end

    on_intel do
      url "https://github.com/mizorewww/course2md/releases/download/v3.0.0-alpha.10/course2md-macos-x86_64"
      sha256 "f4368209fd06d2a81da229bbbb4454bbb219a8739c70a072ed3b005c749782cf"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/mizorewww/course2md/releases/download/v3.0.0-alpha.10/course2md-linux-x86_64"
      sha256 "eebe53c647892af72c7b0bf9c351e61d7169160cf9494511d2f9e53827a80fcd"
    else
      url "https://github.com/mizorewww/course2md/releases/download/v3.0.0-alpha.10/course2md-linux-aarch64"
      sha256 "fd01e989a651e61539e2e9c9f73d81528f33adbc4f2aa7a8d290f308a8a3ef26"
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
