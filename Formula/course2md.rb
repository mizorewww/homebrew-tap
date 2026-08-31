class Course2md < Formula
  desc "Turn course videos (YouTube/Bilibili/local) into illustrated markdown/HTML notes"
  homepage "https://github.com/mizorewww/course2md"
  version "0.5.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/mizorewww/course2md/releases/download/v0.5.0/course2md-macos-arm64"
      sha256 "fb0cb33433d22e5561b7ab5218fbf857b2107ce5df5e48533ab346986fe75a28"

      resource "mlx_metallib" do
        url "https://github.com/mizorewww/course2md/releases/download/v0.5.0/mlx-macos-arm64.metallib"
        sha256 "2b44fa0c3c66477fe205d58014ad1ff6e2ed8466ca2dd9c6111270710e021f98"
      end
    end

    on_intel do
      url "https://github.com/mizorewww/course2md/releases/download/v0.5.0/course2md-macos-x86_64"
      sha256 "74fc8a32b09ed29e70cb6abf701c950c5fce70796c71dadd3044b64c7e5895fd"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/mizorewww/course2md/releases/download/v0.5.0/course2md-linux-x86_64"
      sha256 "3651dbba6e8d9d0274d6404b68f51ef11c3355e6a785691c53493a4c2f1f8a14"
    else
      url "https://github.com/mizorewww/course2md/releases/download/v0.5.0/course2md-linux-aarch64"
      sha256 "bb3c11c09e798a5a1e9aac069e237e5a2dfa2615b57743ab3f6abee6241d0022"
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
