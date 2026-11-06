# Pioneer Healthcare engine data

Builds the configuration image for Healthcare Core. It takes the official
engine configuration image as is and adds our branding on top: the Pioneer
Healthcare logo, the home screen icons and the home/login screen settings.

## Layout

| Folder | What | License |
| --- | --- | --- |
| `pioneer/` | our logo and icons | proprietary, see `LICENSE` |
| `agpl-modified/` | upstream `whiteLabel.json` with our changes | AGPL v3, see `agpl-modified/NOTICE.md` |
| `Dockerfile` | `FROM bahmni/standard-config:1.0.0` + copy both folders to `/etc/bahmni_config/openmrs/` | |

Both folders mirror the paths inside the image, so `pioneer/openmrs/apps/home/logo.png`
ends up at `/etc/bahmni_config/openmrs/apps/home/logo.png`.

## Build

```sh
docker build -t healthcare-core/config .
# another base version:
docker build --build-arg CONFIG_BASE_TAG=1.0.0 -t healthcare-core/config .
```

The container behaves exactly like the base image: its start script copies
`/etc/bahmni_config` to `/usr/local/bahmni_config` (the shared config volume)
and then keeps running.

## Deployer settings (site.env)

```
HC_BRAND_CONFIG_REPO=https://github.com/Pioneeraitech-Healthcare/pioneer-healthcare-engine-data.git
HC_BRAND_CONFIG_REF=main
HC_BRAND_CONFIG_DOCKERFILE=Dockerfile
```

## Changing the branding

Replace or add files under `pioneer/openmrs/...` at the path they should have
in the image. If you need to change another upstream file, put the modified
copy under `agpl-modified/` and record the change in `agpl-modified/NOTICE.md`.
Keep `.gitattributes` as is so images and JSON are stored byte for byte.

When moving to a newer base tag, check that `whiteLabel.json` upstream has not
changed shape; if it has, carry our changes over to the new version.
