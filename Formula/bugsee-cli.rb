class BugseeCli < Formula
  desc "Bugsee CLI — cross-platform symbol collection, conversion, and upload."
  homepage "https://github.com/bugsee/bugsee-cli"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bugsee/bugsee-cli/releases/download/v0.5.0/bugsee-cli-aarch64-apple-darwin.tar.xz"
      sha256 "1b7447acc6a69409912ab3ceb85d3603cf445a0091712292138f0cbb33268bbb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bugsee/bugsee-cli/releases/download/v0.5.0/bugsee-cli-x86_64-apple-darwin.tar.xz"
      sha256 "647bed0ae956e91809311a5dba6cf5db3a12d7c2e5f48572dfdf42993e52bc71"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bugsee/bugsee-cli/releases/download/v0.5.0/bugsee-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a0aaa1191439f4f533ebe34dde9666e9a282a6c7694b8fc68db89889c795c36f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bugsee/bugsee-cli/releases/download/v0.5.0/bugsee-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c6450395583412df463754e7220710ee20dd4b4a9f0003c98ad991af2b0de060"
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
