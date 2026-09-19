#!/usr/bin/env bash
# install.sh — 把 agent-learn skill 安装到你的 AI Agent
#
# 用法：
#   ./install.sh              # 仅 opencode
#   ./install.sh --claude     # 同时装到 Claude Code
#   ./install.sh --codex      # 同时装到 Codex
#   ./install.sh --all        # 全部

set -euo pipefail

SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_SRC="$SRC_DIR/skills/agent-learn"

TARGETS=()

has_flag() {
  local needle="$1"
  shift
  for f in "$@"; do [ "$f" = "$needle" ] && return 0; done
  return 1
}

WANT_ALL=false
for arg in "$@"; do
  case "$arg" in
    --opencode) TARGETS+=("$HOME/.config/opencode/skills") ;;
    --claude)   TARGETS+=("$HOME/.claude/skills") ;;
    --codex)    TARGETS+=("$HOME/.codex/skills") ;;
    --all)      WANT_ALL=true ;;
    -h|--help)  sed -n '2,10p' "$0" | sed 's/^# \?//'; exit 0 ;;
    *) echo "未知参数：$arg" >&2; exit 2 ;;
  esac
done

if [ "$WANT_ALL" = true ]; then
  TARGETS=("$HOME/.config/opencode/skills" "$HOME/.claude/skills" "$HOME/.codex/skills")
elif [ ${#TARGETS[@]} -eq 0 ]; then
  TARGETS=("$HOME/.config/opencode/skills")   # 默认 opencode
fi

[ -d "$SKILL_SRC" ] || { echo "找不到 skill 源目录：$SKILL_SRC" >&2; exit 1; }

echo "agent-learn 安装"
echo "源：$SKILL_SRC"
echo

for base in "${TARGETS[@]}"; do
  dest="$base/agent-learn"
  mkdir -p "$base"
  rm -rf "$dest"
  cp -R "$SKILL_SRC" "$dest"
  echo "  ✓ 已安装 → $dest"
done

echo
echo "完成。重启你的 Agent 后，skill 列表里会出现 agent-learn。"
echo
echo "凭据工具（独立使用，无需安装）："
echo "  $SRC_DIR/bin/set-env <目标.env路径> KEY [KEY...]"
