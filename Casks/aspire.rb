cask "aspire" do
  arch arm: "arm64", intel: "x64"

  version "13.3.5"
  sha256 arm:   "7ae8181bec6dee12d1cfb039dd201d7cfb71b51c674b0f06a853f402742afbd3",
         intel: "dafcf1633a6f2970c017d75287f502b0a033d65ff6acac02899f2761f8d16c62"

  url "https://github.com/microsoft/aspire/releases/download/v#{version}/aspire-cli-osx-#{arch}-#{version}.tar.gz",
      verified: "github.com/microsoft/aspire/"
  name "Aspire CLI"
  desc "CLI for building observable, production-ready distributed applications"
  homepage "https://aspire.dev/"

  livecheck do
    url :url
    strategy :github_latest
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
