class Vela < Formula
  desc "Workspace manager UI for AI coding agents (Claude Code, Codex, Ralph Loop)"
  homepage "https://github.com/hardikshah197/Vela"
  version "1.0.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/hardikshah197/Vela/releases/download/v1.0.0/vela-1.0.0-darwin-arm64.tar.gz"
      sha256 "6fbf186bc41373c5f888795ed85957022f5d77f8fcbf166857fd9e596d1adf71"
    end

    on_intel do
      url "https://github.com/hardikshah197/Vela/releases/download/v1.0.0/vela-1.0.0-darwin-amd64.tar.gz"
      sha256 "91479d5a9ccb721dbafa75e230147fc3f7e445a1f3c4fe6a1d3c1be64641579f"
    end
  end

  def install
    bin.install "bin/vela-server"
    (share/"vela").install "share/vela/dist"

    # Create a convenience wrapper that starts the server
    (bin/"vela").write <<~EOS
      #!/bin/bash
      exec "#{bin}/vela-server" "$@"
    EOS
    chmod 0755, bin/"vela"
  end

  def caveats
    <<~EOS
      Vela is installed! Start the server with:

        vela

      Then open http://localhost:6100 in your browser.

      Configuration:
        Search roots:  Set via UI or VELA_SEARCH_ROOTS env var
        Clone dir:     Set via UI or VELA_CLONE_DIR env var
        Port:          Default 6100, override with PORT env var
        Auth config:   ~/.vela/auth.json

      Requires 'claude' or 'codex' CLI to be installed for the
      respective agent types.
    EOS
  end

  test do
    # Verify binary runs
    assert_match "Running on port", shell_output("#{bin}/vela-server &; sleep 2; kill %1 2>/dev/null; wait 2>/dev/null", 0)
  end
end
