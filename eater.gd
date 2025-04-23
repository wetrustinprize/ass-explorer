extends Node

enum FLAVOUR {
    UNKNOWN,
    IMAGE,
}

const per_flavor_ext: Dictionary = {
    [".png", ".jpg"]: FLAVOUR.IMAGE
}

## Tastes the path and return its flavour
func taste(path: String) -> FLAVOUR:
    for checks in per_flavor_ext.keys():
        for check in checks:
            if path.ends_with(check):
                return per_flavor_ext.get(checks)

    return FLAVOUR.UNKNOWN

## Cooks the path and returns its Resource
func cook(path: String) -> Resource:
    var flavour: FLAVOUR = taste(path)

    match flavour:
        FLAVOUR.IMAGE:
            return Image.load_from_file(path)

    return null