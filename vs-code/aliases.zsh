# Keep `code .` muscle memory working after the move to VSCodium.
# Only shadow `code` when codium is actually installed.
(( $+commands[codium] )) && alias code='codium'
