function fix-rubocop() {
  rubocop --autocorrect --only="$1"; git add .; gc -m "Fixes $1 offenses"
}

function fix-rubocop-unsafe() {
  rubocop --autocorrect-all --only="$1"; git add .; gc -m "Fixes $1 offenses"
}
