class BugseeCli < Formula
  desc "Bugsee CLI — cross-platform symbol collection, conversion, and upload."
  homepage "https://github.com/bugsee/bugsee-cli"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bugsee/bugsee-cli/releases/download/v0.1.1/bugsee-cli-aarch64-apple-darwin.tar.xz"
      sha256 "f34c7d9b3ad32e726438b9133e57e308e045b5678afb8ee6b483484355396824"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bugsee/bugsee-cli/releases/download/v0.1.1/bugsee-cli-x86_64-apple-darwin.tar.xz"
      sha256 "55bdef882bc57b67060de4ff37b2b9b5b5d5e6bee84ff289be4bf9bea72d05bd"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bugsee/bugsee-cli/releases/download/v0.1.1/bugsee-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "afa66ca440686454273313f6324a9735d7c6a3b108665dc617b0517dc07a6930"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bugsee/bugsee-cli/releases/download/v0.1.1/bugsee-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d67e28d5a0cd697eb2235d82a6cf71aa4769a3d54fa472429242bc6eeda3bfb1"
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
