class BugseeCli < Formula
  desc "Bugsee CLI — cross-platform symbol collection, conversion, and upload."
  homepage "https://github.com/bugsee/bugsee-cli"
  version "0.7.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bugsee/bugsee-cli/releases/download/v0.7.1/bugsee-cli-aarch64-apple-darwin.tar.xz"
      sha256 "ba9d4507f6805dc2625c50e15e6df048cce708f2d0c9e860f1427c0394ab3a5b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bugsee/bugsee-cli/releases/download/v0.7.1/bugsee-cli-x86_64-apple-darwin.tar.xz"
      sha256 "20ac1b19f9de6010ac7172aca8cf530901079fe5ca2a2fcbadcb4e50426eaee4"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bugsee/bugsee-cli/releases/download/v0.7.1/bugsee-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d5883cc9ff8b5511382dc9fecfdefe3d8c5e3cd8699a0410d2d9bf9a6a23d937"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bugsee/bugsee-cli/releases/download/v0.7.1/bugsee-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3887d05cf9d0a2f3fc65d0f509a5aef929cca31c9e358fdb98528be5b9f5b8fc"
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
