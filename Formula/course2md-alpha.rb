class Course2mdAlpha < Formula
  desc "Turn course videos (YouTube/Bilibili/local) into illustrated markdown/HTML notes"
  homepage "https://github.com/mizorewww/course2md"
  version "3.0.0-alpha.9"
  license "MIT"

  keg_only "it is the alpha prerelease channel"

  depends_on "ffmpeg"
  depends_on "yt-dlp"
  depends_on "aria2"

  resource "third_party_licenses" do
    url "https://github.com/mizorewww/course2md/releases/download/v3.0.0-alpha.9/course2md-third-party-licenses.txt"
    sha256 "996e2f1c65dc95a533baae7d9910c525c465d9cf124bf0162ae47873b6c8069d"
  end

  on_macos do
    on_arm do
      url "https://github.com/mizorewww/course2md/releases/download/v3.0.0-alpha.9/course2md-macos-arm64"
      sha256 "9d3fe28d129eaf4ff997f78ac252ffa7e483cd222cab3d3f6d049ab58c69a009"

      resource "mlx_metallib" do
        url "https://github.com/mizorewww/course2md/releases/download/v3.0.0-alpha.9/mlx-macos-arm64.metallib"
        sha256 "24d4cfcd3ca8b15ead691e46219f35adabbea64c9f8de4eae9bf293fd8d5eb7b"
      end
    end

    on_intel do
      url "https://github.com/mizorewww/course2md/releases/download/v3.0.0-alpha.9/course2md-macos-x86_64"
      sha256 "6e40b18ec66ae46d2f253f2d990b10ffd8977a0104a2eb2d211cba776f86919d"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/mizorewww/course2md/releases/download/v3.0.0-alpha.9/course2md-linux-x86_64"
      sha256 "41d4415954fbf2e69b69c8a942a61db66b26bf126a0bd5a39e2fa89ccf829b95"
    else
      url "https://github.com/mizorewww/course2md/releases/download/v3.0.0-alpha.9/course2md-linux-aarch64"
      sha256 "72b29923fab586b9e9a5b967d32700c1b8126efc58b350f52d899fbfc69cf3cd"
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
