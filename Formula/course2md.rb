class Course2md < Formula
  desc "Turn course videos (YouTube/Bilibili/local) into illustrated markdown/HTML notes"
  homepage "https://github.com/mizorewww/course2md"
  version "1.1.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/mizorewww/course2md/releases/download/v1.1.0/course2md-macos-arm64"
      sha256 "f6eb86f0419be6864cc4ebfc0bbe8f7d2c3381d26e197de9d3e8db612de32c7b"

      resource "mlx_metallib" do
        url "https://github.com/mizorewww/course2md/releases/download/v1.1.0/mlx-macos-arm64.metallib"
        sha256 "2b44fa0c3c66477fe205d58014ad1ff6e2ed8466ca2dd9c6111270710e021f98"
      end
    end

    on_intel do
      url "https://github.com/mizorewww/course2md/releases/download/v1.1.0/course2md-macos-x86_64"
      sha256 "c5ac7ad36467df08d7dbd93b512592905759e7b42d8235d226db1fc7f6f098a2"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/mizorewww/course2md/releases/download/v1.1.0/course2md-linux-x86_64"
      sha256 "8eb7fd935bc8e4cb0f3cd49626f7163baa1ed1c49fca779234ff3a4de4596e8d"
    else
      url "https://github.com/mizorewww/course2md/releases/download/v1.1.0/course2md-linux-aarch64"
      sha256 "1e094ed802acfee3d8f13483767cb8d402b4f7970520a3a5d723aeddea1dd652"
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
