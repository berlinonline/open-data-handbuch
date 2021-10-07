# New Release Process

- during development, add changes under `DEVELOPMENT` header at the top of `CHANGELOG.md`
- add new version header to `CHANGELOG.md`
- move changes from `DEVELOPMENT` to new version header
- adjust version link in `parts/pages_impressum.template.md`
- adjust version link in `parts/latex_impressum.template.md`
- add, commit, push all changes
- create new tag with version number: `git tag {VERSION_NUMBER}`
- push tag: `git push --tags`