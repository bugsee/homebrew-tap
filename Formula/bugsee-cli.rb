class BugseeCli < Formula
  desc "Bugsee CLI — cross-platform symbol collection, conversion, and upload."
  homepage "https://github.com/bugsee/bugsee-cli"
  version "0.7.11"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bugsee/bugsee-cli/releases/download/v0.7.11/bugsee-cli-aarch64-apple-darwin.tar.xz"
      sha256 "46cd6d1722fba358f7f7843d0062eb2c5ba417d95e30969289d4dec3ef3c055e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bugsee/bugsee-cli/releases/download/v0.7.11/bugsee-cli-x86_64-apple-darwin.tar.xz"
      sha256 "9893c0f02e35b27a07d6ad9467731d1e11d369794b5d3261d804ecf7a1575b22"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bugsee/bugsee-cli/releases/download/v0.7.11/bugsee-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "670f06c78ee2d4ea4678b6a386d5b0c3789c7174e4fc394159ff135b94bb2428"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bugsee/bugsee-cli/releases/download/v0.7.11/bugsee-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3b1532629992bff015e512a5f8499fc5d9f53f111594b86a147e44b720a647d9"
    end
  end

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
