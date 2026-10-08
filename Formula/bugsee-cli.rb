class BugseeCli < Formula
  desc "Bugsee CLI — cross-platform symbol collection, conversion, and upload."
  homepage "https://github.com/bugsee/bugsee-cli"
  version "0.8.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bugsee/bugsee-cli/releases/download/v0.8.1/bugsee-cli-aarch64-apple-darwin.tar.xz"
      sha256 "0ef257f16ecd5d4666590a355ab20c1d6b44d94f1c17aea4b357a21ed96a7ecf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bugsee/bugsee-cli/releases/download/v0.8.1/bugsee-cli-x86_64-apple-darwin.tar.xz"
      sha256 "35f6630cb1f05e9dd46d2cdc05741d72098f0d828fa8790412301c6d56912617"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bugsee/bugsee-cli/releases/download/v0.8.1/bugsee-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7617959bbfb14823a7cb86a1fcf876040b24ff1e5e778b3b557a44f7a375f298"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bugsee/bugsee-cli/releases/download/v0.8.1/bugsee-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4d9d985945f3ec20ce56b0dca0bdf208c0d240ea9855d17ea44c6993619b220b"
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
