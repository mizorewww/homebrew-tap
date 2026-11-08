class Course2mdAlpha < Formula
  desc "Turn course videos (YouTube/Bilibili/local) into illustrated markdown/HTML notes"
  homepage "https://github.com/mizorewww/course2md"
  version "3.0.0-alpha.4"
  license "MIT"

  keg_only "it is the alpha prerelease channel"

  depends_on "ffmpeg"
  depends_on "yt-dlp"
  depends_on "aria2"

  resource "third_party_licenses" do
    url "https://github.com/mizorewww/course2md/releases/download/v3.0.0-alpha.4/course2md-third-party-licenses.txt"
    sha256 "83bb817f03f6302877ef88b8dd3d19d419486bafca7a495d94817b114d670fae"
  end

  on_macos do
    on_arm do
      url "https://github.com/mizorewww/course2md/releases/download/v3.0.0-alpha.4/course2md-macos-arm64"
      sha256 "2682a105842fb98854ec550bdfaf936d30efff2643de4675916a7b80d1643ebc"

      resource "mlx_metallib" do
        url "https://github.com/mizorewww/course2md/releases/download/v3.0.0-alpha.4/mlx-macos-arm64.metallib"
        sha256 "24d4cfcd3ca8b15ead691e46219f35adabbea64c9f8de4eae9bf293fd8d5eb7b"
      end
    end

    on_intel do
      url "https://github.com/mizorewww/course2md/releases/download/v3.0.0-alpha.4/course2md-macos-x86_64"
      sha256 "78f8146d290fd32eb9ed3844e08f9aa746f18708057f52ac497230f3786a6e28"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/mizorewww/course2md/releases/download/v3.0.0-alpha.4/course2md-linux-x86_64"
      sha256 "32882aab7eb794bb03f3b63bd4a03527133b81dc5f04a6becff27d72893f410f"
    else
      url "https://github.com/mizorewww/course2md/releases/download/v3.0.0-alpha.4/course2md-linux-aarch64"
      sha256 "5026820885f7551bd3cbfa4cc0814696ccbefdab2ed148548408ece8be9b15cd"
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
