# newgist.md — spinning up a new gist tool or data repo

Two repo kinds (see style_gist.md): **tool** gists (code: ezr, nuff,
lithp, kah-lua, luamine, luk, repltut) and **data** gists (CSV only:
optimiz=optimize, klassif=classify, textz=text-mining). Both ride
konfig's shared Makefile.

## part vs whole — a section in a file, or a new gist?

    import it  ->  a part   ->  a section in an existing file (nuff.py)
    run it     ->  a whole  ->  its own gist

New gist when ANY of: an app/idea with its own CLI + identity (ezr);
a different language (lithp=lisp, kah-lua=lua); data (optimiz);
non-stdlib deps; wants its own release cadence. Otherwise keep it as
a section in the relevant file. Promoting a file -> gist later is
cheap; merging scattered gists back is not. Cap a one-file lib at
"readable in one sitting" — past that, split by theme or promote.

## recipe (the order that works)

1. BUILD in `~/gists/<name>/`:
     <name>.py (+ test_<name>.py)   konfig-style code (style_code.md)
     ,<name>.md                     man-page README (style_gist.md)
     Makefile                       knobs + include $(KONFIG)/Makefile
     pyproject.toml                 if pip-installable
     banner.txt                     figlet name + tagline
   Verify: `make test`. Data comes from sibling gists (../optimiz,
   ../klassif, ../textz) — never bundled in a tool gist.

2. CREATE the gist (it must exist before any git push). Use the
   GitHub API with the keychain token; POST /gists with the files:
     tok=$(printf 'protocol=https\nhost=github.com\n\n' \
            | git credential fill | awk -F= '/^password=/{print $2}')
     curl -s -X POST -H "Authorization: token $tok" \
          -H "Accept: application/vnd.github+json" \
          https://api.github.com/gists -d @payload.json
   payload = {"description":..,"public":true,"files":{name:{content}}}.
   BIG files (CSVs) go via git push afterward — the API caps payload.

3. Create a public aiez repo from the dir and push:
     gh repo create aiez/<name> --public --source=. --remote=origin --push
   origin is now https://github.com/aiez/<name> (no shortener).

4. WIRE konfig: in `gists.mk` add a `<name>:` target (calls $(sync))
   and put `<name>` on the `gists:` line. Then `make <name>` clones or
   pulls it on a fresh box; `make gists` does the whole constellation.

5. WIRE fyi (the website Tools page):
     fyi/Makefile     add `<name>:<dir>:,<name>.md` to TOOLS
     fyi/etc/tools.txt   one blurb line  `<name>|short description`
     fyi/CLAUDE.md    a row in the curated list
   then `make tools` (pandoc) + push. Page lands at timm.fyi/tool-<name>.html.
   If the gist ALSO ships a long-form `<name>.md` "tour" (genetic-stanza
   tutorial), that routes to a BLOG post, not Tools — render it through
   fyi's `etc/blog.html` template and copy its images into fyi
   `assets/img/`. See fyi/CLAUDE.md "Tools vs Blog".

6. PYPI (optional, code gists): `make push2pypi`. The FIRST upload of
   a NEW project needs an ACCOUNT-scoped token (project-scoped tokens
   cannot create the project -> 403). After it exists, scope a token
   to that project and store it in ~/.pypirc. NEVER paste a token into
   a chat or log; if one leaks, revoke it immediately.

## where a name lives (the rename/retire checklist)

A gist name `<x>` is repeated in many places. Renaming or retiring
means touching ALL of them — grep first: `grep -rn '<x>' ~/gists ~/gits/timm/fyi`.

    inside ~/gists/<x>/        <x>.py test_<x>.py ,<x>.md (header,
                               imports, API, badges, "Files:" links),
                               Makefile (APP MAIN LINT + test target),
                               pyproject.toml (name readme py-modules
                               Homepage url), banner.txt (figlet + url)
    the gist itself            file names (git mv), description (API
                               PATCH /gists/<id>), origin remote url
    konfig/gists.mk            the `<x>:` target + the `gists:` line
    konfig/*.md                style_code.md, newgist.md (the tool list
                               + any "canonical lib" mention)
    fyi/Makefile               TOOLS entry `<x>:<x>:,<x>.md`
    fyi/etc/tools.txt          the `<x>|blurb` line
    fyi/CLAUDE.md              the curated-list row
    fyi pages                  rebuild (`make tools`) -> tool-<x>.html;
                               git rm the stale old page
    PyPI                       (code gists) no rename API — upload the
                               new name, delete old project by hand
                               (web UI only); bump version if needed
    you, by hand               github.com/aiez/<x>; revoke any token

## renaming or retiring a gist

Same list, run as a sweep:
1. `grep -rn '<old>' ~/gists ~/gits/timm/fyi` — the worklist.
2. Rename in-repo: `git mv` files, edit contents, `make test`.
3. Push the renamed files; PATCH the gist description; repoint origin.
4. konfig + fyi edits above; `make tools`; commit konfig, fyi, gist.
5. PyPI: upload new name, hand-delete old project.
6. Retiring (not renaming): drop the `gists.mk` target + `gists:`
   entry, the fyi TOOLS/tools.txt/CLAUDE.md rows, `git rm` the fyi
   page; delete the gist + PyPI project by hand.

## conventions that bit us

- Gists are FLAT — no subdirectories. Multi-dir tools don't fit:
  flatten, or generate dirs at runtime under ~/.cache/konfig/... (see
  konfig isolation; `make death` wipes all generated dirs).
- Data lives in sibling DATA gists, never inside a tool gist. Refer to
  it as `../optimiz/foo.csv` — the sole sanctioned relative path.
- One data gist per task family: optimiz (optimize), klassif
  (classify), textz (text-mining). `!`-suffixed CSV header = klass.
- Always run python `-B` (no __pycache__); .gitignore `__pycache__/`,
  `*.pyc`, `dist/`, `build/`, `*.egg-info/`.
