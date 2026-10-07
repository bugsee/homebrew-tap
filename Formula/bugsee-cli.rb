class BugseeCli < Formula
  desc "Bugsee CLI — cross-platform symbol collection, conversion, and upload."
  homepage "https://github.com/bugsee/bugsee-cli"
  version "0.7.13"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bugsee/bugsee-cli/releases/download/v0.7.13/bugsee-cli-aarch64-apple-darwin.tar.xz"
      sha256 "d8f8a1c49e6cb7ff7e030ad5d998de1fb7139b2c205f3a37b602983b2edcf63e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bugsee/bugsee-cli/releases/download/v0.7.13/bugsee-cli-x86_64-apple-darwin.tar.xz"
      sha256 "1f9589973e796943f297993e25da9991fad819e6730ed8bc98e0cb9b7322afd8"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bugsee/bugsee-cli/releases/download/v0.7.13/bugsee-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9ea6c89be87b4c6007778a6c17a23df734b1a3689e57334b0bcc07239aa5c1cb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bugsee/bugsee-cli/releases/download/v0.7.13/bugsee-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "de95f0f10c375ccd273a365df135cefbd8616bfbfdc0b6c9c117d8b6ea07ed43"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-pc-windows-gnu":    {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "bugsee-cli"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "bugsee-cli"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "bugsee-cli"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "bugsee-cli"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
