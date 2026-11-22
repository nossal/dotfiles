#!/bin/sh
# Instalador remoto dos dotfiles.
#
#   curl -fsSL https://noss.al/dot | sh
#   curl -fsSL https://noss.al/dot | sh -s -- desktop-pessoal
#
# Tudo fica dentro de main para um download interrompido não executar pela metade.

main() {
  set -eu

  DOT_DIR="$HOME/.dotfiles"
  DOT_REPO="${DOTFILES_REPO:-https://github.com/nossal/dotfiles}"
  PROFILE="${1:-}"

  ui_init
  printf ':: %sdot install%s\n' "$C_DIM" "$C_RESET"

  command -v git > /dev/null 2>&1 || die "git é necessário para instalar"
  command -v bash > /dev/null 2>&1 || die "bash é necessário para instalar"

  fetch_repo

  if [ -z "$PROFILE" ] && has_tty; then
    choose_profile
  fi

  # O stdin do sh é o próprio script, então os setups precisam de outra entrada.
  if has_tty; then
    exec bash "$DOT_DIR/bin/dot" ${PROFILE:+"$PROFILE"} < /dev/tty
  fi
  exec bash "$DOT_DIR/bin/dot" ${PROFILE:+"$PROFILE"} < /dev/null
}

ui_init() {
  C_RESET="" C_DIM="" C_ORANGE="" C_GREEN="" C_YELLOW="" C_RED=""
  if [ -t 1 ] && [ -z "${NO_COLOR:-}" ] && [ "${TERM:-dumb}" != "dumb" ]; then
    C_RESET="$(printf '\033[0m')"
    C_DIM="$(printf '\033[2;37m')"
    C_ORANGE="$(printf '\033[38;2;245;77;39m')"
    C_GREEN="$(printf '\033[3;32m')"
    C_YELLOW="$(printf '\033[33m')"
    C_RED="$(printf '\033[31m')"
  fi
}

die() {
  printf '%sx%s %s\n' "$C_RED" "$C_RESET" "$1" >&2
  exit 1
}

warn() {
  printf ' %s!%s %s\n' "$C_YELLOW" "$C_RESET" "$1"
}

ok() {
  printf ' %sv%s %s\n' "$C_GREEN" "$C_RESET" "$1"
}

has_tty() {
  ( : < /dev/tty ) 2> /dev/null
}

fetch_repo() {
  if [ -d "$DOT_DIR/.git" ]; then
    if [ -n "$(git -C "$DOT_DIR" status --porcelain)" ]; then
      warn "~/.dotfiles tem alterações locais, mantendo a versão atual"
    elif git -C "$DOT_DIR" pull --ff-only --quiet; then
      ok "~/.dotfiles atualizado"
    else
      warn "não foi possível atualizar ~/.dotfiles, mantendo a versão atual"
    fi
  elif [ -e "$DOT_DIR" ]; then
    die "~/.dotfiles já existe e não é um repositório Git"
  else
    git clone --quiet "$DOT_REPO" "$DOT_DIR" || die "não foi possível clonar $DOT_REPO"
    ok "repositório clonado em ~/.dotfiles"
  fi
}

list_profiles() {
  awk '
    /^\[/ { in_profiles = ($0 == "[profiles]"); next }
    in_profiles && /=/ {
      gsub(/"/, "")
      split($0, field, /[[:space:]]*=[[:space:]]*/)
      printf "%s\t%s\n", field[1], field[2]
    }
  ' "$DOT_DIR/profiles.toml"
}

choose_profile() {
  saved=""
  if [ -s "$HOME/.config/dot/profile" ]; then
    saved="$(tr -d '[:space:]' < "$HOME/.config/dot/profile")"
  fi
  total="$(list_profiles | wc -l | tr -d ' ')"

  list_profiles | awk -F '\t' -v orange="$C_ORANGE" -v dim="$C_DIM" -v reset="$C_RESET" '
    { printf " %d %s%-18s%s  %s%s%s\n", NR, orange, $1, reset, dim, $2, reset }
  '

  while :; do
    printf ' perfil [Enter = %s]: ' "${saved:-base}"
    IFS= read -r answer < /dev/tty || answer=""
    case "$answer" in
      "")
        PROFILE="$saved"
        return 0
        ;;
      *[!0-9]*)
        ;;
      *)
        if [ "$answer" -ge 1 ] && [ "$answer" -le "$total" ]; then
          PROFILE="$(list_profiles | sed -n "${answer}p" | cut -f1)"
          return 0
        fi
        ;;
    esac
    warn "escolha um número de 1 a $total"
  done
}

main "$@"
