# Maven XDG wrapper - handles both mvn and mvnw
mvn() {
  command mvn -s "$XDG_CONFIG_HOME/maven/settings.xml" "$@"
}
