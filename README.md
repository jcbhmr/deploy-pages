# Deploy to GitHub Pages with preview support

🔮 Like [actions/deploy-pages] but with actual preview support

<p align=center>
  <img src="">
</p>

📁 Uses the `gh-pages` branch deployment technique \
🔓 **Does not** provide origin isolation for previews \
📚 Great for documentation websites \
🧪 Perfect to give first-time contributors a preview \

ℹ If you're waiting for official support, make sure you follow these
Discussions & Issues:

- [[GitHub Pages] Deploy preview option for PRs · community · Discussion #7730](https://github.com/orgs/community/discussions/7730)
- [`preview` timeline? · Issue #180 · actions/deploy-pages](https://github.com/actions/deploy-pages/issues/180)
- [Add support for generating `preview: true` deployment environment URLs? 🧪 · Issue #92 · actions/configure-pages](https://github.com/actions/configure-pages/issues/92)

## Usage

The easiest way to get started is to replace any instances of
[actions/deploy-pages] with [jcbhmr/deploy-pages-with-preview-support] and
[actions/configure-pages] with [jcbhmr/configure-pages-with-preview-support].
Here's an example workflow of what you might use with an npm-based web project:

```yml
# .github/workflows/deploy-pages.yml
name: deploy-pages
on:
  push:
    branches: "main"
  pull_request:
jobs:
  deploy-pages:
    permissions:
      contents: write
    environment:
      name: github-pages
      url: ${{ steps.deploy-pages.outputs.page_url }}
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: "21"
          cache: npm
      - run: npm ci
      - id: configure-pages
        uses: jcbhmr/configure-pages-with-preview@v2
      - run: npm run build
        env:
          BASE_URL: ${{ steps.configure-pages.outputs.base_url }}/
      - uses: actions/upload-pages-artifact@v2
      - id: deploy-pages
        uses: jcbhmr/deploy-pages-with-preview@v1
```

You can still deploy to your site normally.

ℹ Make sure that your GitHub Pages setting is set to use the `gh-pages` branch
as a deployment source instead of GitHub Actions. We use the `gh-pages` branch
instead of via GitHub Actions so that we can retain the deployment state without
it expiring like workflow run artifacts do.
