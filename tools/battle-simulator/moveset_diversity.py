"""Explicit extra validation when ordered lists concealed identical movesets."""
import json

from lab.data import canonical, digest, extract
from roster_audit import OUT, summarize


class ExtendedStore:
    def __init__(self, base, identity, rows):
        self.base, self.identity, self.rows = base, identity, rows

    def __getattr__(self, name):
        return getattr(self.base, name)

    def results(self, identity):
        yield from self.base.results(identity)
        if identity == self.identity:
            yield from self.rows


def diversity_retests(store, search, validation):
    groups = {}
    for row in validation["rows"]:
        groups.setdefault(row["build"]["species"], []).append(row)
    extra = []
    for species, rows in groups.items():
        sets = {tuple(sorted(r["build"]["moves"])) for r in rows}
        if len(rows) < 2 or len(sets) != 1:
            continue
        alternatives = [r for r in search["rows"] if r["build"]["species"] == species
                        and tuple(sorted(r["build"]["moves"])) not in sets]
        if alternatives:
            extra.append(alternatives[0]["build"])
    path = OUT / "moveset-diversity-retests.json"
    receipt = json.loads(path.read_text()) if path.exists() else None
    if not receipt or receipt["base_run"] != validation["run"] or receipt["subjects"] != extra:
        receipt = {"base_run": validation["run"], "subjects": extra, "rows": []}
        if extra:
            from pp_transport_probe import candidate_module
            patched = candidate_module()
            receipt["transport_patch_sha256"] = patched.patch_sha256
            engine = patched.RomEngine(extract())
            engine.metadata.update({"transport": "lab-v2-pp-guard", "transport_patch_sha256": patched.patch_sha256,
                                    "audit_stage": "moveset-diversity-retest"})
            # The first original finalist's 32 fixtures define the identical
            # opponent builds, sides, and seeds for every additional finalist.
            fixtures = store.run(validation["run"])["config"]["scenarios"][:32]
            if len(fixtures) != 32:
                raise ValueError("expected sixteen mirrored validation fixtures")
            try:
                for build in extra:
                    key = digest(canonical([build]).encode())[:16]
                    for original in fixtures:
                        side = original["name"].rsplit(";side=", 1)[-1]
                        spec = {**original, side: [build], "name": f"moveset diversity retest | subject={key};side={side}"}
                        result = engine.run(spec)
                        if result["status"] == "error" or result["failures"]:
                            raise ValueError(f"diversity replay failed: {build['species']}: {result.get('error')}")
                        spec = result["scenario"]
                        receipt["rows"].append({"id": digest(canonical(spec).encode()), "block_id": digest(canonical([build, spec["seed"]]).encode())[:24],
                                                "status": result["status"], "spec": spec, "result": result})
                    print(f"Distinct moveset validated: {build['species']} / 32 battles", flush=True)
            finally:
                engine.close()
        path.write_text(json.dumps(receipt, indent=2))
    proxy = ExtendedStore(store, validation["run"], receipt["rows"])
    subjects = validation["subjects"] + extra
    validation = {**validation, "subjects": subjects, "rows": summarize(proxy, validation["run"], subjects)}
    return proxy, validation, receipt
