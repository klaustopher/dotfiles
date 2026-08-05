# Versioned postgresql formulae are keg-only, so pg_dump & friends are not on
# the PATH by default. Pick the highest installed version.
pg_prefixes=(/opt/homebrew/opt/postgresql@<->(-/NnOn))
if (( $#pg_prefixes )); then
  export PATH="$pg_prefixes[1]/bin:$PATH"
fi
unset pg_prefixes
