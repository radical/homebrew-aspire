cask "aspire" do
  arch arm: "arm64", intel: "x64"

  version "13.4.0"
  sha256 arm:   "606f34125d526bc9cd9fa432727c6a9e6a1244fe63679340dc84aec3bace95a3",
         intel: "b8cb8c7f8d368895a59f9e9c9c6cb30a35267600acf5db873737205f4e8e9aa6"

  url "https://ci.dot.net/public/aspire/13.4.0-preview.1.26279.30/aspire-cli-osx-#{arch}-#{version}.tar.gz",
      verified: "ci.dot.net/public/aspire/"
  name "Aspire CLI"
  desc "CLI for building observable, production-ready distributed applications"
  homepage "https://aspire.dev/"

  # Skip livecheck on this staging dogfood tap; the daily staging channel does
  # not have a stable version surface, and the upstream Homebrew/homebrew-cask
  # submission will use the real livecheck block from
  # eng/homebrew/aspire.rb.template.
  livecheck do
    skip "Aspire 13.4 staging dogfood; tracks the aka.ms/dotnet/9/aspire/rc/daily channel."
  end

  depends_on :macos

  binary "aspire"

  # Lets the Aspire CLI identify the install source without path heuristics.
  postflight do
    File.write("#{staged_path}/.aspire-install.json", %Q({"source":"brew"}\n))
  end

  uninstall_preflight do
    [
      "#{caskroom_path}/.aspire-bundle-version",
      "#{caskroom_path}/bundle",
      *Pathname.glob("#{caskroom_path}/versions/#{version}_*"),
    ].each { |path| FileUtils.rm_r(path, force: true) }
    versions_dir = Pathname("#{caskroom_path}/versions")
    versions_dir.rmdir if versions_dir.directory? && versions_dir.children.empty?
  end

  zap trash: []
end
