class Course2md < Formula
  desc "Turn course videos (YouTube/Bilibili/local) into illustrated markdown/HTML notes"
  homepage "https://github.com/mizorewww/course2md"
  version "1.4.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/mizorewww/course2md/releases/download/v1.4.1/course2md-macos-arm64"
      sha256 "33320e80fad974d2bc5edf5fc559600a91c25ea8b62300ae5f4cdeafd8ab372a"

      resource "mlx_metallib" do
        url "https://github.com/mizorewww/course2md/releases/download/v1.4.1/mlx-macos-arm64.metallib"
        sha256 "24d4cfcd3ca8b15ead691e46219f35adabbea64c9f8de4eae9bf293fd8d5eb7b"
      end
    end

    on_intel do
      url "https://github.com/mizorewww/course2md/releases/download/v1.4.1/course2md-macos-x86_64"
      sha256 "ce6d3682ca3170569527d4abf45f9fda3ae0dc08c863375995696dca7c5faeba"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/mizorewww/course2md/releases/download/v1.4.1/course2md-linux-x86_64"
      sha256 "9ab8fd1fe9933781a35edee4eaecdf0aa6d0bf0d8ffc50d63334d9646635a873"
    else
      url "https://github.com/mizorewww/course2md/releases/download/v1.4.1/course2md-linux-aarch64"
      sha256 "54d337288756001425c9af7ded22fa149b629930ca89c62a3db1d79e9ed965f6"
    end
  end

  depends_on "ffmpeg"
  depends_on "yt-dlp"

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
          Apple Silicon builds default to the CoreML backend (no extra
          dependencies; models auto-download on first run).
        EOS
      end
    end
  end

  test do
    assert_match "course2md", shell_output("#{bin}/course2md --version")
  end
end
