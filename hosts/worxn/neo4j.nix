{ config, lib, pkgs, myConfig, ... }:

# Neo4j — graph store backing the Graphiti temporal knowledge graph
# (~/workspace/projects/marktguru/mg-recipe-graphiti).
#
# Bind addresses stay on loopback: this holds curated Recipe project
# knowledge and must not become reachable on the LAN or over wg0.
#
# First-run password bootstrap (the module has no initialPassword
# option, and the store-managed conf makes the default neo4j/neo4j
# first-login flow awkward):
#
#   sudo systemctl stop neo4j
#   sudo -u neo4j NEO4J_CONF=/var/lib/neo4j/conf \
#     neo4j-admin dbms set-initial-password "$(cat ~/workspace/nixos/.secrets/neo4j.password.nix)"
#   sudo systemctl start neo4j
#
# set-initial-password only applies while no auth database exists yet.
# To rotate later, use `ALTER CURRENT USER SET PASSWORD FROM ... TO ...`
# in cypher-shell, or stop the service and delete
# /var/lib/neo4j/data/dbms/auth before re-running the command above.
#
# Handy:
#   systemctl status neo4j
#   journalctl -u neo4j -f
#   cypher-shell -a bolt://localhost:7687 -u neo4j   # prompts for password
#   http://localhost:7474                            # Neo4j Browser

{
  services.neo4j = {
    enable = true;

    # Loopback only. The module already defaults to 127.0.0.1, but this
    # is load-bearing for a private knowledge graph, so state it.
    defaultListenAddress = "127.0.0.1";

    bolt.enable = true; # 127.0.0.1:7687 — the driver/Graphiti port
    http.enable = true; # 127.0.0.1:7474 — Neo4j Browser

    # The HTTPS connector defaults to on and its "legacy" SSL policy
    # expects a keypair in directories.certificates. Pointless for a
    # loopback-only service, and it fails noisily without certs.
    https.enable = false;

    # Neo4j otherwise sizes itself against total RAM and can claim a
    # lot of a laptop. This corpus is ~40 documents; modest is plenty.
    extraServerConfig = ''
      server.memory.heap.initial_size=512m
      server.memory.heap.max_size=2g
      server.memory.pagecache.size=512m

      # On by default — it logs "Anonymous Usage Data is being sent to
      # Neo4j" on every start. Off, for a private knowledge graph.
      dbms.usage_report.enabled=false
    '';
  };

  # Neo4j keeps its store under /var/lib/neo4j (directories.home).
  # Worth knowing before any nixos-rebuild that changes the package:
  # a major-version bump may need a store migration.
}
