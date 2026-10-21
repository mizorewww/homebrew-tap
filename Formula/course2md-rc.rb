class Course2mdRc < Formula
  desc "Turn course videos (YouTube/Bilibili/local) into illustrated markdown/HTML notes"
  homepage "https://github.com/mizorewww/course2md"
  version "2.0.0-rc.16"
  license "MIT"

  keg_only "it is the rc prerelease channel"

  depends_on "ffmpeg"
  depends_on "yt-dlp"
  depends_on "aria2"

  on_macos do
    on_arm do
      url "https://github.com/mizorewww/course2md/releases/download/v2.0.0-rc.16/course2md-macos-arm64"
      sha256 "29927d94fbe6e1f69d99af9ea4e71c6ab8fd1c6df6ed69a5545b5deaff540497"

      resource "mlx_metallib" do
        url "https://github.com/mizorewww/course2md/releases/download/v2.0.0-rc.16/mlx-macos-arm64.metallib"
        sha256 "24d4cfcd3ca8b15ead691e46219f35adabbea64c9f8de4eae9bf293fd8d5eb7b"
      end
    end

    on_intel do
      url "https://github.com/mizorewww/course2md/releases/download/v2.0.0-rc.16/course2md-macos-x86_64"
      sha256 "5121ee0959704bb218f1e5b1c5cee78b0827338cd721d3dfcccb4489c233128a"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/mizorewww/course2md/releases/download/v2.0.0-rc.16/course2md-linux-x86_64"
      sha256 "f6a7e99cc8cc10a752f42be44d67db6c06351179d7f028f4335b9140b41559f2"
    else
      url "https://github.com/mizorewww/course2md/releases/download/v2.0.0-rc.16/course2md-linux-aarch64"
      sha256 "840c958e9aacfdc19920b3c35db32767d335fda4ae46011145af00523beae950"
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
