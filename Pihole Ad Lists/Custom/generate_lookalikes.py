#!/usr/bin/env python3
"""
Generate "Lookalike Domains.txt" -- registered typosquat / lookalike domains of
commonly phished brands (rnicrosoft.com, paypa1.com, micros0ft.com ...).

How it works
  1. Build permutations of each brand name: homoglyphs (m->rn, l->1, o->0, w->vv,
     d->cl ...), omitted / repeated / swapped letters, adjacent-key typos,
     inserted hyphens, and brand-word combos (paypal-login.com, secure-chase.com).
  2. Ask public DNS (Cloudflare DNS-over-HTTPS) which of them are actually
     registered. Unregistered names are dropped -- there is nothing to block.
  3. Drop the kinds of permutation that collide with real, unrelated sites:
       - TLD swaps (ring.net, office.net -- office.net is a Microsoft CDN)
       - omission / adjacent-key / swap edits of brands of 5 letters or fewer
         (ring -> wing.com, chase -> chose.com, apple -> apply.com)
       - anything in EXCLUDE below (found by checking the Tranco top-1M list)
  Brand-owned defensive registrations (Microsoft owns rnicrosoft.com, Meta owns
  facebok.com) are kept on purpose: blocking them only turns a typo redirect
  into a block page.

Run:  python3 generate_lookalikes.py      (~3-5 minutes; uses curl if present)
Refreshed monthly by Homelab_Ansible/Playbooks/Pihole_Refresh_Lookalike_Domains.yml
Writes "Lookalike Domains.txt" next to this script. Commit both files.
"""
import concurrent.futures as cf
import datetime
import json
import os
import shutil
import subprocess
import urllib.request

BRANDS = {
    "microsoft": "com", "outlook": "com", "office": "com", "xbox": "com",
    "google": "com", "apple": "com", "icloud": "com", "amazon": "com",
    "paypal": "com", "github": "com", "discord": "com", "netflix": "com",
    "facebook": "com", "instagram": "com", "linkedin": "com", "dropbox": "com",
    "docusign": "com", "adobe": "com", "coinbase": "com", "ebay": "com",
    "walmart": "com", "usps": "com", "fedex": "com", "chase": "com",
    "wellsfargo": "com", "bankofamerica": "com", "cloudflare": "com",
    "synology": "com", "tailscale": "com", "steampowered": "com",
    "steamcommunity": "com", "ring": "com", "spotify": "com", "yahoo": "com",
}

COMBO_WORDS = ["login", "secure", "verify", "support", "account", "signin", "help"]

# Registered lookalikes that are real, unrelated (or brand-operated, in-use) sites.
EXCLUDE = {
    "cloud.com",      # Citrix (icloud minus the i), Tranco rank ~1,200
    "wal-mart.com",   # Walmart's own legacy domain
    "lcloud.com",     # unrelated cloud provider
}

KBD = {
    'q': 'wa', 'w': 'qes', 'e': 'wrd', 'r': 'etf', 't': 'ryg', 'y': 'tuh',
    'u': 'yij', 'i': 'uok', 'o': 'ipl', 'p': 'ol', 'a': 'qsz', 's': 'awdz',
    'd': 'sefx', 'f': 'drgc', 'g': 'fthv', 'h': 'gyjb', 'j': 'hukn',
    'k': 'jilm', 'l': 'kop', 'z': 'asx', 'x': 'zsdc', 'c': 'xdfv',
    'v': 'cfgb', 'b': 'vghn', 'n': 'bhjm', 'm': 'njk',
}

GLYPHS = [
    ('m', 'rn'), ('rn', 'm'), ('l', '1'), ('i', '1'), ('o', '0'), ('i', 'l'),
    ('l', 'i'), ('w', 'vv'), ('vv', 'w'), ('d', 'cl'), ('cl', 'd'), ('a', '4'),
    ('e', '3'), ('s', '5'), ('g', 'q'), ('u', 'v'), ('n', 'm'), ('m', 'n'),
]


def permutations(name):
    """Return {label: edit_type} for one brand name."""
    out = {}

    def add(label, kind):
        if label != name and label not in out and not label.startswith('-') \
                and not label.endswith('-') and '--' not in label:
            out[label] = kind

    for a, b in GLYPHS:
        start = 0
        while (j := name.find(a, start)) != -1:
            add(name[:j] + b + name[j + len(a):], 'glyph')
            start = j + 1
    for i in range(len(name)):
        if i > 0:
            add(name[:i] + '-' + name[i:], 'hyphen')
        add(name[:i] + name[i] + name[i:], 'repeat')
        if i < len(name) - 1:
            add(name[:i] + name[i + 1] + name[i] + name[i + 2:], 'swap')
        add(name[:i] + name[i + 1:], 'omit')
        for c in KBD.get(name[i], ''):
            add(name[:i] + c + name[i + 1:], 'key')
    return out


def keep(brand, label, kind):
    """False-positive filter (see module docstring)."""
    if len(brand) <= 5:
        if kind in ('omit', 'key', 'swap'):
            return False
        if kind == 'glyph' and not any(s in label for s in ('0', '1', '3', '4', '5', 'rn', 'vv', 'cl')):
            return False
    return True


def candidates():
    found = {}
    for brand, tld in BRANDS.items():
        for label, kind in permutations(brand).items():
            if keep(brand, label, kind):
                found.setdefault(f"{label}.{tld}", brand)
        for w in COMBO_WORDS:
            found.setdefault(f"{brand}-{w}.com", brand)
            found.setdefault(f"{w}-{brand}.com", brand)
    return {d: b for d, b in found.items() if d not in EXCLUDE}


CURL = shutil.which("curl")


def doh_query(url):
    """Fetch a DoH JSON answer. Uses curl when present (Windows' bundled Python
    can't verify certificates); falls back to urllib (fine on Linux/Semaphore)."""
    if CURL:
        r = subprocess.run(
            [CURL, "-sS", "--max-time", "15", "-H", "accept: application/dns-json", url],
            capture_output=True, text=True, timeout=30)
        return json.loads(r.stdout)
    req = urllib.request.Request(url, headers={"accept": "application/dns-json"})
    with urllib.request.urlopen(req, timeout=15) as resp:
        return json.load(resp)


def registered(domain):
    """True if the domain exists (DNS status NOERROR), None if the lookup failed."""
    url = f"https://cloudflare-dns.com/dns-query?name={domain}&type=NS"
    for _ in range(3):
        try:
            return doh_query(url).get("Status") == 0
        except Exception:
            continue
    return None


def main():
    cands = candidates()
    with cf.ThreadPoolExecutor(48) as pool:
        results = dict(zip(cands, pool.map(registered, cands)))
    failed = sorted(d for d, ok in results.items() if ok is None)
    live = sorted(d for d, ok in results.items() if ok)
    if len(failed) > len(cands) * 0.05:
        raise SystemExit(f"{len(failed)} of {len(cands)} DNS lookups failed -- not writing a partial list")

    today = datetime.date.today().isoformat()
    header = [
        "# Title: Lookalike Domains (typosquats of commonly phished brands)",
        f"# Generated: {today} by generate_lookalikes.py",
        f"# Brands: {len(BRANDS)}  Checked: {len(cands)}  Registered (listed): {len(live)}",
        "# Re-run the script to refresh; registered lookalikes change over time.",
    ]
    path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "Lookalike Domains.txt")
    with open(path, "w", newline="\n") as f:
        f.write("\n".join(header + live) + "\n")
    print(f"checked {len(cands)}, registered {len(live)}, lookup failures {len(failed)} -> {path}")


if __name__ == "__main__":
    main()
