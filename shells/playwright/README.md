# Playwright flake

Due to the nature of NixOS special folder structure [Playwright](https://playwright.dev/) needs to be pointed at the location of installed browsers. This is the purpose of a nix package called `playwright-driver.browsers`. The flake installs this package and sets an environment variable `PLAYWRIGHT_BROWSERS_PATH`:

```bash
[me@mymachine:~/workspace/projects/project]$ echo $PLAYWRIGHT_BROWSERS_PATH
/nix/store/xyz...123-playwright-browsers

[me@mymachine:~/workspace/projects/project]$ ls $PLAYWRIGHT_BROWSERS_PATH
chromium-1155  chromium_headless_shell-1155  ffmpeg-1011  firefox-1471  webkit-2123
```

As the browser versions of your NodeJS playwright project and your nixpkgs have to match, you might need to configure the exact path (i.e. including the version) to the executable in the Playwright launcher options:

```js
/**
 * @type {import('@web/test-runner').TestRunnerConfig}
 */
export default {
  browsers: [
    playwrightLauncher({
      product: "chromium",
      launchOptions: {
        // replace {VERSION} with the desired browser version, e.g. /chromium-1155
        executablePath: `${process.env.PLAYWRIGHT_BROWSERS_PATH}/chromium-{VERSION}/chrome-linux/chrome`,
      },
    }),
  ],
  // ...
};
```

## Resources

- https://wiki.nixos.org/wiki/Playwright
- https://modern-web.dev/docs/test-runner/browser-launchers/playwright/#customizing-launch-options
