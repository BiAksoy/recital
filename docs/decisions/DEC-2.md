---
id: DEC-2
date: 2026-10-22
title: The content is public-domain poems and LibriVox's readings of them, bundled as one file and streamed with just_audio
status: accepted
areas: [content, player]
---

**Context.** The demo needs the shape of a real content app: something new each day,
lists to browse, a page for each item, and a player. Its content has to be real, free to
publish, and plain enough that nobody reads the demo for it.

**Decision.** Twelve poems first published before 1931, each with the readings LibriVox
volunteers recorded for its weekly poetry project, which LibriVox releases into the public
domain. The texts come from public-domain editions; `assets/catalog.json` names the source
of every text, year and recording. The poem of the day is the catalogue in order, one a
day. Recordings stream from archive.org with just_audio (not in `versions.md`; it is the
player Flutter apps of this stack use) and play while the app is open; there is no
background audio. Rejected: invented sample content, which a demo about doing things
properly should not have.

**Consequences.** The player needs the network. Background audio and the lock screen would
need audio_service.
