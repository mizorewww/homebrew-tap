class Course2md < Formula
  desc "Turn course videos (YouTube/Bilibili/local) into illustrated markdown/HTML notes"
  homepage "https://github.com/mizorewww/course2md"
  version "1.2.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/mizorewww/course2md/releases/download/v1.2.0/course2md-macos-arm64"
      sha256 "68912e32cdab2f56a854cae4b29ecece2f3f4326c958d3299c40dbe55d1f9fe6"

      resource "mlx_metallib" do
        url "https://github.com/mizorewww/course2md/releases/download/v1.2.0/mlx-macos-arm64.metallib"
        sha256 "2b44fa0c3c66477fe205d58014ad1ff6e2ed8466ca2dd9c6111270710e021f98"
      end
    end

    on_intel do
      url "https://github.com/mizorewww/course2md/releases/download/v1.2.0/course2md-macos-x86_64"
      sha256 "7d6c2b517c24714e15fe08c22c0edc3c9d13158a7d0cb072ab5eede9092ef7d3"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/mizorewww/course2md/releases/download/v1.2.0/course2md-linux-x86_64"
      sha256 "00c0ea0ee4a698d9465ce10324bbbba78a3ceada1f77fed1ddfeb835c0f70793"
    else
      url "https://github.com/mizorewww/course2md/releases/download/v1.2.0/course2md-linux-aarch64"
      sha256 "758a703078869efa586c7b209d1948d455ca35d65d7f2f66778b9b06e42d8f4b"
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
