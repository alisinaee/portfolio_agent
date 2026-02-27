#!/usr/bin/env python3
"""Update docs/agent-rules.md with concise project memory for AI agents."""

from __future__ import annotations

import argparse
import datetime as dt
import hashlib
import re
import subprocess
from pathlib import Path

MAX_RULES = 15
MAX_CHANGE_ENTRIES = 20
MAX_SNAPSHOT_BULLETS = 12
MIN_SNAPSHOT_BULLETS = 6
DEFAULT_DOCS_FILE = "docs/agent-rules.md"

KEYWORDS = (
    "must",
    "should",
    "need",
    "needs",
    "want",
    "behavior",
    "app should",
    "always",
    "never",
    "after each change",
)

DEFAULT_RULES = [
    "Keep this file concise and clear for AI agents.",
    "Update this file after assistant turns that edit repo-tracked files.",
    "Capture new user behavior instructions as short imperative rules.",
    "Skip updates when there are no file edits and no new behavior instructions.",
    "Retain only the latest 20 change entries.",
]


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Create or update docs/agent-rules.md for AI-agent memory."
    )
    parser.add_argument("--project-root", required=True, help="Absolute project root path")
    parser.add_argument(
        "--docs-file",
        default=DEFAULT_DOCS_FILE,
        help="Docs markdown path (relative to project root or absolute)",
    )
    parser.add_argument(
        "--changed-files",
        default="",
        help="Comma-separated changed files; falls back to git diff --name-only",
    )
    parser.add_argument("--change-summary", default="", help="Short summary of what changed")
    parser.add_argument("--user-message", default="", help="Latest user instruction text")
    return parser.parse_args()


def _normalize_ws(value: str) -> str:
    return re.sub(r"\s+", " ", value.strip())


def _section_body(content: str, name: str) -> str:
    pattern = re.compile(
        rf"^## {re.escape(name)}\n(?P<body>.*?)(?=^## |\Z)",
        re.MULTILINE | re.DOTALL,
    )
    match = pattern.search(content)
    return match.group("body").strip("\n") if match else ""


def _parse_bullets(section_body: str) -> list[str]:
    bullets: list[str] = []
    for line in section_body.splitlines():
        stripped = line.strip()
        if stripped.startswith("- "):
            bullets.append(stripped[2:].strip())
    return bullets


def _parse_recent_entries(section_body: str) -> list[str]:
    entries: list[str] = []
    current: list[str] = []
    for raw in section_body.splitlines():
        line = raw.rstrip()
        if line.startswith("### "):
            if current:
                entries.append("\n".join(current).strip())
            current = [line]
            continue
        if current:
            current.append(line)
    if current:
        entries.append("\n".join(current).strip())
    return [entry for entry in entries if entry]


def _extract_fingerprint(entry: str) -> str:
    match = re.search(r"<!--\s*fingerprint:([a-f0-9]+)\s*-->", entry)
    return match.group(1) if match else ""


def _parse_existing(content: str) -> dict[str, list[str] | str]:
    snapshot = _parse_bullets(_section_body(content, "Project Snapshot"))
    rules = _parse_bullets(_section_body(content, "Behavior Rules"))
    recent = _parse_recent_entries(_section_body(content, "Recent Changes (Last 20)"))
    last_updated = ""
    for line in _section_body(content, "Last Updated").splitlines():
        stripped = line.strip()
        if stripped.startswith("- "):
            last_updated = stripped[2:].strip()
            break
    return {
        "snapshot": snapshot,
        "rules": rules,
        "recent": recent,
        "last_updated": last_updated,
    }


def _canonical_rule(rule: str) -> str:
    return re.sub(r"[^a-z0-9]+", "", rule.lower())


def _to_imperative(text: str) -> str:
    sentence = _normalize_ws(text).strip(" -•\t")
    sentence = sentence.rstrip(".!?")
    sentence = re.sub(
        r"^(please|also|and)\s+",
        "",
        sentence,
        flags=re.IGNORECASE,
    )
    sentence = re.sub(
        r"^(this skill|skill|it|docs|docs file|this file|auto docs|app)\s+should\s+",
        "",
        sentence,
        flags=re.IGNORECASE,
    )
    sentence = re.sub(
        r"^should\s+",
        "",
        sentence,
        flags=re.IGNORECASE,
    )
    sentence = re.sub(
        r"^(you\s+need\s+to|need\s+to|needs\s+to|must)\s+",
        "",
        sentence,
        flags=re.IGNORECASE,
    )
    if not sentence:
        return ""
    sentence = sentence[0].upper() + sentence[1:]
    lowered = sentence.lower()
    if lowered.startswith("be "):
        sentence = f"Keep docs {sentence[3:]}"
    elif lowered.startswith("have "):
        sentence = f"Use {sentence[5:]}"
    elif lowered.startswith("include "):
        sentence = f"Use {sentence[8:]}"

    if not re.match(
        r"^(Keep|Update|Create|Use|Run|Skip|Track|Record|Limit|Read|Write|Ensure|Maintain)\b",
        sentence,
    ):
        sentence = f"Ensure {sentence[0].lower()}{sentence[1:]}"
    return sentence


def extract_rules_from_message(message: str) -> list[str]:
    if not message.strip():
        return []

    candidates: list[str] = []
    for line in message.splitlines():
        stripped = line.strip()
        if not stripped:
            continue
        for sentence in re.split(r"[.!?;]+", stripped):
            segment = _normalize_ws(sentence)
            if not segment:
                continue
            lowered = segment.lower()
            if not any(keyword in lowered for keyword in KEYWORDS):
                continue
            rule = _to_imperative(segment)
            if 8 <= len(rule) <= 180:
                candidates.append(rule)

    deduped: list[str] = []
    seen: set[str] = set()
    for rule in candidates:
        key = _canonical_rule(rule)
        if key and key not in seen:
            deduped.append(rule)
            seen.add(key)
    return deduped


def merge_rules(existing: list[str], incoming: list[str]) -> list[str]:
    merged: list[str] = []
    seen: set[str] = set()
    for rule in existing + incoming:
        normalized = _normalize_ws(rule).rstrip(".")
        if not normalized:
            continue
        normalized = normalized + "."
        key = _canonical_rule(normalized)
        if key in seen:
            continue
        merged.append(normalized)
        seen.add(key)
        if len(merged) >= MAX_RULES:
            break
    return merged


def parse_changed_files(raw: str) -> list[str]:
    if not raw.strip():
        return []
    values = [_normalize_ws(part) for part in raw.split(",")]
    return [value for value in values if value]


def git_changed_files(project_root: Path) -> list[str]:
    try:
        result = subprocess.run(
            ["git", "-C", str(project_root), "diff", "--name-only"],
            check=False,
            capture_output=True,
            text=True,
        )
    except OSError:
        return []
    if result.returncode != 0:
        return []
    files = [line.strip() for line in result.stdout.splitlines() if line.strip()]
    return files


def _read_text(path: Path) -> str:
    try:
        return path.read_text(encoding="utf-8")
    except OSError:
        return ""


def _extract_dependencies(pubspec_text: str) -> list[str]:
    deps: list[str] = []
    in_deps = False
    for line in pubspec_text.splitlines():
        if re.match(r"^dependencies:\s*$", line):
            in_deps = True
            continue
        if in_deps and re.match(r"^[a-zA-Z_].*:\s*$", line) and not line.startswith("  "):
            break
        if in_deps:
            match = re.match(r"^\s{2}([a-zA-Z0-9_]+):\s*(.*)$", line)
            if not match:
                continue
            name, value = match.group(1), match.group(2)
            if name == "flutter":
                continue
            if value.strip() == "":
                continue
            deps.append(name)
    return deps


def build_project_snapshot(project_root: Path) -> list[str]:
    bullets: list[str] = []
    main_path = project_root / "lib/main.dart"
    app_path = project_root / "lib/portfolio_app.dart"
    flat_path = project_root / "lib/portfolio_flat_page.dart"
    models_path = project_root / "lib/models/portfolio_models.dart"
    data_path = project_root / "lib/data/portfolio_snapshot.dart"
    widget_test_path = project_root / "test/widget_test.dart"
    widgets_dir = project_root / "lib/widgets"
    pubspec_path = project_root / "pubspec.yaml"

    main_text = _read_text(main_path)
    app_text = _read_text(app_path)
    test_text = _read_text(widget_test_path)
    pubspec_text = _read_text(pubspec_path)

    app_title = ""
    title_match = re.search(r"title:\s*'([^']+)'", main_text)
    if title_match:
        app_title = title_match.group(1)

    home_widget = ""
    home_match = re.search(r"home:\s*const\s+([A-Za-z0-9_]+)\(", main_text)
    if home_match:
        home_widget = home_match.group(1)

    if main_text:
        detail = "Entry point `lib/main.dart` starts `MaterialApp`."
        if app_title or home_widget:
            detail = (
                f"Entry point `lib/main.dart` starts `MaterialApp`"
                f"{f' (`{app_title}`)' if app_title else ''}"
                f"{f' with `{home_widget}` as home' if home_widget else ''}."
            )
        bullets.append(detail)

    if "_PortfolioMode { animated, flat }" in app_text:
        bullets.append(
            "UI flow has two modes in `lib/portfolio_app.dart`: animated kinetic landing and flat scrollable sections."
        )

    if flat_path.exists():
        bullets.append(
            "`lib/portfolio_flat_page.dart` renders the long-form section layout with in-page navigation and section tracking."
        )

    if models_path.exists() and data_path.exists():
        bullets.append(
            "Data model is typed in `lib/models/portfolio_models.dart` and populated by `const portfolioSnapshot` in `lib/data/portfolio_snapshot.dart`."
        )

    if widgets_dir.exists():
        widget_files = sorted(path.name for path in widgets_dir.glob("*.dart"))
        if widget_files:
            preview = ", ".join(f"`{name}`" for name in widget_files[:4])
            suffix = "" if len(widget_files) <= 4 else f", +{len(widget_files) - 4} more"
            bullets.append(
                f"Reusable UI widgets live in `lib/widgets` ({len(widget_files)} files): {preview}{suffix}."
            )

    deps = _extract_dependencies(pubspec_text)
    if deps:
        preview = ", ".join(f"`{dep}`" for dep in deps[:4])
        suffix = "" if len(deps) <= 4 else f", +{len(deps) - 4} more"
        bullets.append(f"Primary package dependencies include {preview}{suffix}.")

    if widget_test_path.exists():
        covers: list[str] = []
        if "shared app bar remains stable" in test_text:
            covers.append("mode switching")
        if "animated menu open state" in test_text:
            covers.append("animated menu behavior")
        if "flat mode has section menu" in test_text:
            covers.append("flat-mode section menu")
        cover_text = ", ".join(covers) if covers else "core widget behavior"
        bullets.append(
            f"Widget tests in `test/widget_test.dart` validate {cover_text}."
        )

    platforms = [
        name
        for name in ("android", "ios", "web", "macos", "linux", "windows")
        if (project_root / name).exists()
    ]
    if platforms:
        bullets.append(
            "Repository targets Flutter multi-platform builds: "
            + ", ".join(f"`{name}`" for name in platforms)
            + "."
        )

    fallback = [
        "Keep updates focused on architecture, behavior rules, and high-impact changes only.",
        "Prefer short, implementation-focused bullets over narrative prose.",
    ]

    for item in fallback:
        if len(bullets) >= MIN_SNAPSHOT_BULLETS:
            break
        if item not in bullets:
            bullets.append(item)

    return bullets[:MAX_SNAPSHOT_BULLETS]


def _summarize_changed_files(files: list[str], limit: int = 8) -> str:
    if not files:
        return "none"
    preview = ", ".join(f"`{item}`" for item in files[:limit])
    if len(files) > limit:
        preview += f", +{len(files) - limit} more"
    return preview


def _normalize_summary(summary: str, changed_files: list[str], bootstrapping: bool) -> str:
    cleaned = _normalize_ws(summary)
    if cleaned:
        return cleaned.rstrip(".") + "."
    if bootstrapping:
        return "Bootstrapped docs from the current repository state."
    if changed_files:
        return "Captured code changes from this assistant turn."
    return "Captured behavior-only update from user instructions."


def make_fingerprint(changed_files: list[str], summary: str, new_rules: list[str]) -> str:
    payload = (
        "|".join(sorted(changed_files))
        + "||"
        + summary
        + "||"
        + "|".join(sorted(_canonical_rule(rule) for rule in new_rules))
    )
    return hashlib.sha1(payload.encode("utf-8")).hexdigest()[:12]


def render_change_entry(
    timestamp: str,
    changed_files: list[str],
    summary: str,
    new_rule_count: int,
    fingerprint: str,
) -> str:
    if new_rule_count > 0:
        impact = f"Added or refreshed {new_rule_count} behavior rule(s) from user instructions."
    elif changed_files:
        impact = "Recorded code-level deltas for future AI context."
    else:
        impact = "Recorded behavior-only updates for future AI context."

    lines = [
        f"### {timestamp}",
        f"- Changed files: {_summarize_changed_files(changed_files)}",
        f"- Summary: {summary}",
        f"- Behavior impact: {impact}",
        f"<!-- fingerprint:{fingerprint} -->",
    ]
    return "\n".join(lines)


def render_markdown(
    snapshot: list[str],
    rules: list[str],
    recent_entries: list[str],
    last_updated: str,
) -> str:
    lines: list[str] = []
    lines.append("# AI Agent Rules & Change Memory")
    lines.append("")
    lines.append("## Project Snapshot")
    for bullet in snapshot:
        lines.append(f"- {bullet}")
    lines.append("")
    lines.append("## Behavior Rules")
    for rule in rules:
        lines.append(f"- {rule}")
    lines.append("")
    lines.append("## Recent Changes (Last 20)")
    if recent_entries:
        for index, entry in enumerate(recent_entries[:MAX_CHANGE_ENTRIES]):
            if index > 0:
                lines.append("")
            lines.extend(entry.splitlines())
    else:
        lines.append("- No recorded changes yet.")
    lines.append("")
    lines.append("## Last Updated")
    lines.append(f"- {last_updated}")
    lines.append("")
    return "\n".join(lines)


def now_local_iso() -> str:
    return dt.datetime.now(dt.timezone.utc).astimezone().replace(microsecond=0).isoformat()


def resolve_docs_path(project_root: Path, docs_file: str) -> Path:
    docs_path = Path(docs_file)
    if docs_path.is_absolute():
        return docs_path
    return project_root / docs_path


def main() -> int:
    args = parse_args()
    project_root = Path(args.project_root).expanduser().resolve()
    docs_path = resolve_docs_path(project_root, args.docs_file)
    docs_exists = docs_path.exists()

    existing_content = docs_path.read_text(encoding="utf-8") if docs_exists else ""
    parsed = _parse_existing(existing_content) if docs_exists else {
        "snapshot": [],
        "rules": [],
        "recent": [],
        "last_updated": "",
    }

    incoming_changed_files = parse_changed_files(args.changed_files)
    changed_files = incoming_changed_files or git_changed_files(project_root)
    new_rules = extract_rules_from_message(args.user_message)

    if docs_exists and not changed_files and not new_rules:
        print("No update needed: no file edits and no new behavior rules.")
        return 0

    snapshot = build_project_snapshot(project_root)
    base_rules = parsed["rules"] if docs_exists else DEFAULT_RULES
    merged_rules = merge_rules(base_rules, new_rules)

    existing_entries = list(parsed["recent"])
    updated_entries = list(existing_entries)

    bootstrapping = not docs_exists
    summary = _normalize_summary(args.change_summary, changed_files, bootstrapping)
    fingerprint = make_fingerprint(changed_files, summary, new_rules)
    existing_fingerprints = {_extract_fingerprint(entry) for entry in existing_entries}

    if fingerprint and fingerprint not in existing_fingerprints:
        timestamp = now_local_iso()
        updated_entries.insert(
            0,
            render_change_entry(
                timestamp=timestamp,
                changed_files=changed_files,
                summary=summary,
                new_rule_count=len(new_rules),
                fingerprint=fingerprint,
            ),
        )

    updated_entries = updated_entries[:MAX_CHANGE_ENTRIES]

    snapshot_changed = snapshot != parsed["snapshot"]
    rules_changed = merged_rules != parsed["rules"]
    entries_changed = updated_entries != existing_entries
    needs_write = bootstrapping or snapshot_changed or rules_changed or entries_changed

    if not needs_write:
        print("No update needed: content already up to date.")
        return 0

    docs_path.parent.mkdir(parents=True, exist_ok=True)
    last_updated = now_local_iso()
    output = render_markdown(snapshot, merged_rules, updated_entries, last_updated)
    docs_path.write_text(output, encoding="utf-8")
    print(f"Updated {docs_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
