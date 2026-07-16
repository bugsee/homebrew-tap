class BugseeCli < Formula
  desc "Bugsee CLI — cross-platform symbol collection, conversion, and upload."
  homepage "https://github.com/bugsee/bugsee-cli"
  version "0.7.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bugsee/bugsee-cli/releases/download/v0.7.3/bugsee-cli-aarch64-apple-darwin.tar.xz"
      sha256 "5b28b7b606c2c9a3d0f8dd025b1b7d04ef1b4dc95b3c215f3362bbd4624734de"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bugsee/bugsee-cli/releases/download/v0.7.3/bugsee-cli-x86_64-apple-darwin.tar.xz"
      sha256 "10790e896c8b7257364f3b8f73b18bc5490fc4364ce5766a6fa716672b746a83"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bugsee/bugsee-cli/releases/download/v0.7.3/bugsee-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "af9bc3bf52b223bbeb0a4b2fbcb905a73c4d6c5715e3ed1966f27b32e5240a9d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bugsee/bugsee-cli/releases/download/v0.7.3/bugsee-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6b721a0257493c8f6ac1960f7ba6bacbd5eb80d7412978f02430a37db7a17943"
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
