class Course2md < Formula
  desc "Turn course videos (YouTube/Bilibili/local) into illustrated markdown/HTML notes"
  homepage "https://github.com/mizorewww/course2md"
  version "2.0.1"
  license "MIT"

  depends_on "ffmpeg"
  depends_on "yt-dlp"
  depends_on "aria2"

  on_macos do
    on_arm do
      url "https://github.com/mizorewww/course2md/releases/download/v2.0.1/course2md-macos-arm64"
      sha256 "ac3cdf909214cf46a79fa6ce80a320d2cd69c5925ca4c23bd3e24872d92bf061"

      resource "mlx_metallib" do
        url "https://github.com/mizorewww/course2md/releases/download/v2.0.1/mlx-macos-arm64.metallib"
        sha256 "46e7a9b39d8404957b176f443149b449f2eadc2a37147f62c576c6a543d2a9df"
      end
    end

    on_intel do
      url "https://github.com/mizorewww/course2md/releases/download/v2.0.1/course2md-macos-x86_64"
      sha256 "2d26587af13bd36d138faaf6c8f86fd0a69b85f093a6f884b8b3a9644f47188d"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/mizorewww/course2md/releases/download/v2.0.1/course2md-linux-x86_64"
      sha256 "3899be0f2006251187519fce79e78fc9f9a6c4bc944dd78b9d1954876ece219a"
    else
      url "https://github.com/mizorewww/course2md/releases/download/v2.0.1/course2md-linux-aarch64"
      sha256 "06c4618994972be2984bee677ca0205dc1789266a725ad97424bdf12a9e05d41"
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
