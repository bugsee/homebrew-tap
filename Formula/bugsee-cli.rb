class BugseeCli < Formula
  desc "Bugsee CLI — cross-platform symbol collection, conversion, and upload."
  homepage "https://github.com/bugsee/bugsee-cli"
  version "0.7.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bugsee/bugsee-cli/releases/download/v0.7.0/bugsee-cli-aarch64-apple-darwin.tar.xz"
      sha256 "7379f224f899bb94407dacc16b37eca082d2a81bd13d12e2bfaea02137163382"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bugsee/bugsee-cli/releases/download/v0.7.0/bugsee-cli-x86_64-apple-darwin.tar.xz"
      sha256 "cf3079c74cf0f2d9fe9cdc99daf3ad5c685dc2072af6f101267a4a49c4eca236"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bugsee/bugsee-cli/releases/download/v0.7.0/bugsee-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0d16bd640b6e86b45b8f2a751adc8573208353266e93a406048bc5cc5d918a3f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bugsee/bugsee-cli/releases/download/v0.7.0/bugsee-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "dacac24e03e6a88f58bccc3bac27c58c35c9a98db70ae3efbfded0b99276ce66"
    end
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
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
    bin.install "bugsee-cli" if OS.mac? && Hardware::CPU.arm?
    bin.install "bugsee-cli" if OS.mac? && Hardware::CPU.intel?
    bin.install "bugsee-cli" if OS.linux? && Hardware::CPU.arm?
    bin.install "bugsee-cli" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
