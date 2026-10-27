class Course2mdRc < Formula
  desc "Turn course videos (YouTube/Bilibili/local) into illustrated markdown/HTML notes"
  homepage "https://github.com/mizorewww/course2md"
  version "2.0.0-rc.18"
  license "MIT"

  keg_only "it is the rc prerelease channel"

  depends_on "ffmpeg"
  depends_on "yt-dlp"
  depends_on "aria2"

  on_macos do
    on_arm do
      url "https://github.com/mizorewww/course2md/releases/download/v2.0.0-rc.18/course2md-macos-arm64"
      sha256 "5790d82092ffd6c93014a90718b04aa0424b44faf64876cb745c6778ece8f7d7"

      resource "mlx_metallib" do
        url "https://github.com/mizorewww/course2md/releases/download/v2.0.0-rc.18/mlx-macos-arm64.metallib"
        sha256 "46e7a9b39d8404957b176f443149b449f2eadc2a37147f62c576c6a543d2a9df"
      end
    end

    on_intel do
      url "https://github.com/mizorewww/course2md/releases/download/v2.0.0-rc.18/course2md-macos-x86_64"
      sha256 "608934decd1a83e42600524b31a469d4c22456670ebd506a7474c227ee824495"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/mizorewww/course2md/releases/download/v2.0.0-rc.18/course2md-linux-x86_64"
      sha256 "72f1fc1951e98bb288b173f702ee673a2ed41b43d3d7dbb71526df1c2c7bf172"
    else
      url "https://github.com/mizorewww/course2md/releases/download/v2.0.0-rc.18/course2md-linux-aarch64"
      sha256 "13866d0068797d0769677afa38fb7bb24d4e5d99aaecb7f8750feb830ea43605"
    end
  end

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
