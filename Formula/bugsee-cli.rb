class BugseeCli < Formula
  desc "Bugsee CLI — cross-platform symbol collection, conversion, and upload."
  homepage "https://github.com/bugsee/bugsee-cli"
  version "0.7.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bugsee/bugsee-cli/releases/download/v0.7.8/bugsee-cli-aarch64-apple-darwin.tar.xz"
      sha256 "27a8ebaf2dbdc0789aced58ace377135d05a71fdf59a62475656f284f0d90132"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bugsee/bugsee-cli/releases/download/v0.7.8/bugsee-cli-x86_64-apple-darwin.tar.xz"
      sha256 "1017892f353e57caf766160ba23254e4e97be184c519bac924c7d1e402d199de"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bugsee/bugsee-cli/releases/download/v0.7.8/bugsee-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4df8aeff99ffdc1aa1d642bd009fca651ec78c6f9da06826a8892a0b1e9f152b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bugsee/bugsee-cli/releases/download/v0.7.8/bugsee-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a66f232df493244460133ee196f964509e11c1ad13986470e2b68c230c1af748"
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
