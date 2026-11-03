class Course2mdAlpha < Formula
  desc "Turn course videos (YouTube/Bilibili/local) into illustrated markdown/HTML notes"
  homepage "https://github.com/mizorewww/course2md"
  version "3.0.0-alpha.1"
  license "MIT"

  keg_only "it is the alpha prerelease channel"

  depends_on "ffmpeg"
  depends_on "yt-dlp"
  depends_on "aria2"

  resource "third_party_licenses" do
    url "https://github.com/mizorewww/course2md/releases/download/v3.0.0-alpha.1/course2md-third-party-licenses.txt"
    sha256 "ac5e997a1bf38c6c45566b33d17943b2e6b698bdfe70aa5a2d275b9672d1572b"
  end

  on_macos do
    on_arm do
      url "https://github.com/mizorewww/course2md/releases/download/v3.0.0-alpha.1/course2md-macos-arm64"
      sha256 "8d413cbac23875e7f58a5ff666644a69851699bc841b6990b2fcdbd88dd2d446"

      resource "mlx_metallib" do
        url "https://github.com/mizorewww/course2md/releases/download/v3.0.0-alpha.1/mlx-macos-arm64.metallib"
        sha256 "24d4cfcd3ca8b15ead691e46219f35adabbea64c9f8de4eae9bf293fd8d5eb7b"
      end
    end

    on_intel do
      url "https://github.com/mizorewww/course2md/releases/download/v3.0.0-alpha.1/course2md-macos-x86_64"
      sha256 "4073687837c0d8f9ad9013ec1ecff715a16a416d0307b8d0858e4994ce121de9"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/mizorewww/course2md/releases/download/v3.0.0-alpha.1/course2md-linux-x86_64"
      sha256 "614ad341680d48e45908beaa7206310697bc25d29372aa074fe4a2dec3a08ebf"
    else
      url "https://github.com/mizorewww/course2md/releases/download/v3.0.0-alpha.1/course2md-linux-aarch64"
      sha256 "8a7e0a75d2de0a5981b4fa719482f12bcbab0aee7c1b2b8c82210690e86c4977"
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
