class Course2md < Formula
  desc "Turn course videos (YouTube/Bilibili/local) into illustrated markdown/HTML notes"
  homepage "https://github.com/mizorewww/course2md"
  version "0.7.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/mizorewww/course2md/releases/download/v0.7.2/course2md-macos-arm64"
      sha256 "df5deb85e7f9e35659ef89ea47d21bcf7b48353e17b173c55b82069f3a39d42a"

      resource "mlx_metallib" do
        url "https://github.com/mizorewww/course2md/releases/download/v0.7.2/mlx-macos-arm64.metallib"
        sha256 "2b44fa0c3c66477fe205d58014ad1ff6e2ed8466ca2dd9c6111270710e021f98"
      end
    end

    on_intel do
      url "https://github.com/mizorewww/course2md/releases/download/v0.7.2/course2md-macos-x86_64"
      sha256 "5f43e1e330d73544d904108451bff0a5712a67be2938ee7e0d84175641b684e7"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/mizorewww/course2md/releases/download/v0.7.2/course2md-linux-x86_64"
      sha256 "b55af05b71cfda92af5a1fa63ed14de5e50f80346d568aced0c7f93ec6f1a7fe"
    else
      url "https://github.com/mizorewww/course2md/releases/download/v0.7.2/course2md-linux-aarch64"
      sha256 "1388686c659974e25a2bf2e14be8cba66bbb65fdcda12ff423224e57aaf0c8d3"
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
