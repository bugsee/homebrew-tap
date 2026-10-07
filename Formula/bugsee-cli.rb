class BugseeCli < Formula
  desc "Bugsee CLI — cross-platform symbol collection, conversion, and upload."
  homepage "https://github.com/bugsee/bugsee-cli"
  version "0.8.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bugsee/bugsee-cli/releases/download/v0.8.0/bugsee-cli-aarch64-apple-darwin.tar.xz"
      sha256 "9a18e5206b5dccb1f412e05482f46fa50de544da49dee86f072c45e8d058c7a5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bugsee/bugsee-cli/releases/download/v0.8.0/bugsee-cli-x86_64-apple-darwin.tar.xz"
      sha256 "99b6c173fbf274faa7c8ab4fc9ec96fc730414e83fa65679c524a15bbf19c318"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bugsee/bugsee-cli/releases/download/v0.8.0/bugsee-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "13d211a9ae373be76f22e66377d54c590ea877f9351593be857e57b9ed79d961"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bugsee/bugsee-cli/releases/download/v0.8.0/bugsee-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "653258675bc088d1ab123f3824aaf3a22f547078fd6ca1ff3e99e0e3084e77c4"
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
