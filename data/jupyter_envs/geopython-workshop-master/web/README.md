# Workshop website

This [workshop](https://geopython.github.io/geopython-workshop) is powered
by [MkDocs](https://www.mkdocs.org) which facilitates easy management
of website content and publishing.

## Setting up the website environment locally

```bash
# build a virtual Python environment in isolation
python3 -m venv geopython-workshop
cd geopython-workshop
# download the website from GitHub
git clone https://github.com/geopython/geopython-workshop.git
cd geopython-workshop/web
# install required dependencies
pip install -r requirements.txt
# build the website
mkdocs build
# serve locally
mkdocs serve  # website is made available on http://localhost:8000/
```

## Content management workflow

### Overview

The basic workflow is as follows:

- manage content
- commit updates
- publish to the live site

### Adding a page

```bash
vi docs/new-page.md  # add content
vi mkdocs.yml  # add to navigation section
# edit any other files necessary which may want to link to the new page
git add docs/new-page.md
git commit -m 'add new page on topic x' docs/new-page.md mkdocs.yml
git push origin master
```

### Updating a page

Like adding a page. Edit and commit/push.

## Publishing updates to the live site

Updates are automatically pushed to GitHub Pages.  To publish updates
manually:

```bash
# NOTE: you require access privileges to the GitHub repository
# to publish live updates
mkdocs gh-deploy -m 'add new page on topic x'
```
