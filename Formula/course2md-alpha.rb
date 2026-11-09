class Course2mdAlpha < Formula
  desc "Turn course videos (YouTube/Bilibili/local) into illustrated markdown/HTML notes"
  homepage "https://github.com/mizorewww/course2md"
  version "3.0.0-alpha.6"
  license "MIT"

  keg_only "it is the alpha prerelease channel"

  depends_on "ffmpeg"
  depends_on "yt-dlp"
  depends_on "aria2"

  resource "third_party_licenses" do
    url "https://github.com/mizorewww/course2md/releases/download/v3.0.0-alpha.6/course2md-third-party-licenses.txt"
    sha256 "d0c5e2cb8801ccbed0b9794a4c503a5a87af5f0337eb107f913950574fb8620a"
  end

  on_macos do
    on_arm do
      url "https://github.com/mizorewww/course2md/releases/download/v3.0.0-alpha.6/course2md-macos-arm64"
      sha256 "76aa18e352feb7cda1009f3865ca0225b8bc07aab877bc5ba54effc0093e897e"

      resource "mlx_metallib" do
        url "https://github.com/mizorewww/course2md/releases/download/v3.0.0-alpha.6/mlx-macos-arm64.metallib"
        sha256 "24d4cfcd3ca8b15ead691e46219f35adabbea64c9f8de4eae9bf293fd8d5eb7b"
      end
    end

    on_intel do
      url "https://github.com/mizorewww/course2md/releases/download/v3.0.0-alpha.6/course2md-macos-x86_64"
      sha256 "f3a6de28d608b80aba05dbc0c591014312b99024ae7a6c3c3b1b4065c406ab6e"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/mizorewww/course2md/releases/download/v3.0.0-alpha.6/course2md-linux-x86_64"
      sha256 "107ac85889adb97d7be47b4535b7e1e6f8ac6caa92cdc56361587893f677fede"
    else
      url "https://github.com/mizorewww/course2md/releases/download/v3.0.0-alpha.6/course2md-linux-aarch64"
      sha256 "7ef871dbfa043900174325b0446405e288fef1fa82c7c71d1bc0c66509261438"
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
